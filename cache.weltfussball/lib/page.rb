require 'pp'
require 'date'
require 'nokogiri'



module Worldfootball


class Page

  def self.from_file( path )
    html = File.open( path, 'r:utf-8' ) {|f| f.read }
    new( html )
  end

  def initialize( html )
    @html = html
  end

  def doc
    ## note: if we use a fragment and NOT a document - no access to page head (and meta elements and such)
    @doc ||= Nokogiri::HTML( @html )
  end

  def title
   # <title>Bundesliga 2010/2011 &raquo; Spielplan</title>
     @title ||= doc.css( 'title' ).first
     @title.text  ## get element's text content
  end

  def keywords
     # <meta name="keywords"
     #  content="Bundesliga, 2010/2011, Spielplan, KSV Superfund, SC Magna Wiener Neustadt, SV Ried, FC Wacker Innsbruck, Austria Wien, Sturm Graz, SV Mattersburg, LASK Linz, Rapid Wien, RB Salzburg" />
     @keywords ||= doc.css( 'meta[name="keywords"]' ).first
     @keywords[:content]  ## get content attribute
     ## or      doc.xpath( '//meta[@name="keywords"]' ).first
     ## pp keywords
     # puts "  #{keywords[:content]}"

     # keywords = doc.at( 'meta[@name="Keywords"]' )
     # pp keywords
     ## check for
  end



##  <!-- [generated 2020-06-30 22:30:19] -->
##  <!-- [generated 2020-06-30 22:30:19] -->
GENERATED_RE = %r{
  <!--
    [ ]+
    \[generated
        [ ]+
      (?<date>\d+-\d+-\d+)
        [ ]+
      (?<time>\d+:\d+:\d+)
    \]
    [ ]+
    -->
   }x


   def generated
      @generated ||= begin
        m=GENERATED_RE.match( @html )
        if m
         DateTime.strptime( "#{m[:date]} #{m[:time]}", '%Y-%m-%d %H:%M:%S')
        else
         puts "!! WARN - no generated timestamp found in page"
         nil
        end
      end
   end

   def seasons
    # <select name="saison" ...
    @seasons ||= begin
       recs = []
       season = doc.css( 'select[name="saison"]').first
       options = season.css( 'option' )

       options.each do |option|
          recs << { name: squish(option.text),
                    slug: option[:value]
                  }
       end
       recs
    end
  end



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
     print tr.text.strip
     print "\n"

     last_round = tr.text.strip
   else   ## assume table row (tr) is match line
     tds = tr.css( 'td' )

     date_str  = squish( tds[0].text )
     time_str  = squish( tds[1].text )
     team1_str = squish( tds[2].text )
     ## skip vs (-)
     team2_str = squish( tds[4].text )
     score_str = squish( tds[5].text )

     ##  todo - find a better way to check for live match
     ## check for live badge image
     ## <td class="dunkel" align="center">
     ##   <img src="https://s.hs-data.com/bilder/shared/live/2.png" /></a>
     ## </td>
     img = tds[6].css( 'img' ).first
     if img && img[:src].index( '/live/')
       puts "!! WARN: live match, resetting score from #{score_str} to -:-"
       score_str = '-:-'  # note: -:- gets replaced to ---
     end


     date_str = last_date_str    if date_str.empty?

     print '[%03d]    ' % (i+1)
     print "%-10s | " % date_str
     print "%-5s | " % time_str
     print "%-22s | " % team1_str
     print "%-22s | " % team2_str
     print score_str
     print "\n"


     ## change  2:1 (1:1)  to 2-1 (1-1)
     score_str = score_str.gsub( ':', '-' )

     ## convert date from 25.10.2019 to 2019-25-10
     date     = Date.strptime( date_str, '%d.%m.%Y' )

     rows << { round: last_round,
               date:  date.strftime( '%Y-%m-%d' ),
               time:  time_str,
               team1: team1_str,
               score: score_str,
               team2: team2_str
             }

     last_date_str = date_str
   end
  end # each tr (table row)

    rows
   end
 end  # matches


######################
##   helper methods

def squish( str )
  str = str.strip
  str = str.gsub( /[ \t\n]+/, ' ' )  ## fold whitespace to one max.
  str
end


end # class Page

end # module Worldfootball
