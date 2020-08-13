
module Worldfootball
  class Page

class Schedule < Page  ## note: use nested class for now - why? why not?

  def matches
    @matches ||= begin

 # <div class="data">
 # <table class="standard_tabelle" cellpadding="3" cellspacing="1">

 table = doc.css( 'div.data table.standard_tabelle' ).first    ## get table
 # puts table.class.name  #=> Nokogiri::XML::Element
 # puts table.text

 trs   = table.css( 'tr' )
 # puts trs.size
 i = 0

 last_date_str = nil
 last_round    = nil

 rows = []

 trs.each do |tr|
   i += 1


   if tr.text.strip =~ /Spieltag/ ||
      tr.text.strip =~ /[1-9]\.[ ]Runde|
                           Qual\.[ ][1-9]\.[ ]Runde|  # see EL or CL Quali
                           Qualifikation|     # see CA Championship
                           Sechzehntelfinale|   # see EL
                           Achtelfinale|
                           Viertelfinale|
                           Halbfinale|
                           Finale|
                           Gruppe[ ][A-Z]|    # see CL
                           Playoffs           # see EL Quali
                           /x
     puts
     print '[%03d] ' % (i+1)
     print squish( tr.text )
     print "\n"

     last_round = tr.text.strip
   else   ## assume table row (tr) is match line
     tds = tr.css( 'td' )

     date_str  = squish( tds[0].text )
     time_str  = squish( tds[1].text )

     # was: team1_str = squish( tds[2].text )

     ## <td><a href="/teams/hibernian-fc/" title="Hibernian FC">Hibernian FC</a></td>
     ##  todo/check: check if tooltip title always equals text - why? why not?
     team1_anchor = tds[2].css( 'a' )[0]
     assert( team1_anchor, 'no team1 <a> found')
     team1_str    = squish( team1_anchor.text )
     team1_ref    = norm_team_ref( team1_anchor[:href] )

     ##  <td> - </td>
     ## e.g. -
     vs_str =    squish( tds[3].text )  ## use to assert column!!!
     assert( vs_str == '-',  "- for vs. expected; got #{vs_str}")
     ## was: team2_str = squish( tds[4].text )

     ## <td><a href="/teams/st-johnstone-fc/" title="St. Johnstone FC">St. Johnstone FC</a></td>
     team2_anchor = tds[4].css( 'a' )[0]
     assert( team2_anchor, 'no team2 <a> found')
     team2_str    = squish( team2_anchor.text )
     team2_ref    = norm_team_ref( team2_anchor[:href] )

     ### was: score_str = squish( tds[5].text )
     ## <a href="/spielbericht/premiership-2020-2021-hibernian-fc-st-johnstone-fc/" title="Spielschema Hibernian FC - St. Johnstone FC">-:-</a>

     score_anchor = tds[5].css( 'a')[0]
     assert( score_anchor, 'no score<a> found')
     score_str    = squish( score_anchor.text )
     score_ref    = norm_score_ref( score_anchor[:href] )


     ##  todo - find a better way to check for live match
     ## check for live badge image
     ## <td>
     ##   <img src="https://s.hs-data.com/bilder/shared/live/2.png" /></a>
     ## </td>
     img = tds[6].css( 'img' )[0]
     if img && img[:src].index( '/live/')
       puts "!! WARN: live match badge, resetting score from #{score_str} to -:-"
       score_str = '-:-'  # note: -:- gets replaced to ---
     end


     date_str = last_date_str    if date_str.empty?

     print '[%03d]    ' % (i+1)
     print "%-10s | " % date_str
     print "%-5s | " % time_str
     print "%-22s | " % team1_str
     print "%-22s | " % team2_str
     print "%-10s | " % score_str
     print score_ref
     print "\n"


     ## change  2:1 (1:1)  to 2-1 (1-1)
     score_str = score_str.gsub( ':', '-' )

     ## convert date from 25.10.2019 to 2019-25-10
     date     = Date.strptime( date_str, '%d.%m.%Y' )

     rows << { round: last_round,
               date:  date.strftime( '%Y-%m-%d' ),
               time:  time_str,
               team1: { text: team1_str,
                        ref:  team1_ref
                      },
               score: score_str,
               team2: { text: team2_str,
                        ref:  team2_ref
                      },
               report: score_ref
             }

     last_date_str = date_str
   end
  end # each tr (table row)

    rows
   end
 end  # matches



 def teams
  @teams ||= begin
     h = {}
     matches.each do |match|
       ## index by name/text for now NOT ref - why? why not?
       [match[:team1], match[:team2]].each do |team|
         rec = h[ team[:text] ] ||= { count: 0,
                                      name: team[ :text],
                                      ref:  team[ :ref ] }
         rec[ :count ] += 1
         ## todo/check:  check/assert that name and ref are always equal - why? why not?
       end
     end

     h.values
  end
 end

 def rounds
  @rounds ||= begin
     h = {}
     matches.each do |match|
       rec = h[ match[:round] ] ||= { count: 0,
                                      name: match[ :round] }
        rec[ :count ] += 1
     end

     h.values
  end
 end


 def seasons
  # <select name="saison" ...
  @seasons ||= begin
     recs = []
     season = doc.css( 'select[name="saison"]').first
     options = season.css( 'option' )

     options.each do |option|
        recs << { text: squish( option.text ),
                  ref:  norm_season_ref( option[:value] )
                }
     end
     recs
  end
end


######
## helpers

## todo/check - rename/use HREF and not REF - why? why not?
REF_SCORE_RE = %r{^/spielbericht/
                     ([a-z0-9_-]+)/$}x

def norm_score_ref( str )
  ## check ref format / path
  if m=REF_SCORE_RE.match( str )
    m[1]
  else
    puts "!! ERROR: unexpected score href format >#{str}<"
    exit 1
  end
end


REF_TEAM_RE  = %r{^/teams/
                     ([a-z0-9_-]+)/$}x

def norm_team_ref( str )
  ## check ref format / path
  if m=REF_TEAM_RE.match( str )
    m[1]
  else
    puts "!! ERROR: unexpected team href format >#{str}<"
    exit 1
  end
end


REF_SEASON_RE = %r{^/alle_spiele/
                        ([a-z0-9_-]+)/$}x

def norm_season_ref( str )
  ## check ref format / path
  if m=REF_SEASON_RE.match( str )
    m[1]
  else
    puts "!! ERROR: unexpected season href format >#{str}<"
    exit 1
  end
end
end # class Schedule


  end # class Page
end # module Worldfootball