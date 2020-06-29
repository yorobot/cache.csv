###
#  (re)format datafile with all sections


require '../boot'


OUT_DIR='../../../openfootball/england'
# OUT_DIR='./o'


## split into league + season
  ##  e.g. Österr. Bundesliga 2015/16   ## or 2015-16
  ##       World Cup 2018
  LEAGUE_SEASON_HEADING_RE =  %r{^
         (?<league>.+?)     ## non-greedy
            \s+
         (?<season>\d{4}
            (?:[\/-]\d{1,4})?     ## optional 2nd year in season
         )
            $}x

def split_league( str )   ## todo/check: rename to parse_league(s) - why? why not?
    ## split into league / stage / ... e.g.
    ##  => Österr. Bundesliga 2018/19, Regular Season
    ##  => Österr. Bundesliga 2018/19, Championship Round
    ##  etc.
    values = str.split( /[,<>‹›]/ )  ## note: allow , > < or › ‹ for now
    values = values.map { |value| value.strip }   ## remove all whitespaces
    values
  end

def read_secs( path )

    txt = File.open( path, 'r:utf-8' ) { |f| f.read }

    secs=[]     # sec(tion)s
    SportDb::OutlineReader.parse( txt ).each do |node|
      if node[0] == :h1
        ## check for league (and stage) and season
        heading = node[1]
        values = split_league( heading )
        if m=values[0].match( LEAGUE_SEASON_HEADING_RE )
          puts "league >#{m[:league]}<, season >#{m[:season]}<"

           secs << { league: m[:league],
                     season: m[:season],
                     stage:  values[1],     ## note: defaults to nil if not present
                     lines:  []
                   }
        else
          puts "** !!! ERROR - cannot match league and season in heading; season missing?"
          pp heading
          exit 1
        end
      elsif node[0] == :p   ## paragraph with (text) lines
        lines = node[1]
        ## note: skip lines if no heading seen
        if secs.empty?
          puts "** !!! WARN - skipping lines (no heading):"
          pp lines
        else
          ## todo/check: unroll paragraphs into lines or pass along paragraphs - why? why not?
          secs[-1][:lines] += lines
        end
      else
        puts "** !!! ERROR - unknown line type; for now only heading 1 for leagues supported; sorry:"
        pp node
        exit 1
      end
    end

  secs
end



def round_to_i( name )
     ## try to convert to number; if NOT found return 999 for now
     ##   e.g. assume Final or such is higher than Matchday 48

    ## convert rounds / matchday to integer from string
    ##   e.g. "Matchday 1"  => 1

        if name =~ /\b(?:Matchday|Round) (\d+)\b/
          $1.to_i
        else
          ### todo: add chech for finals/semifinal and such
          puts "!! WARN - cannot convert round to number - >#{name}<"
          999
        end
end


def read_matches( lines, season: )
    season = SportDb::Import::Season.new( season )
    start = if season.year?
        Date.new( season.start_year, 1, 1 )
      else
        Date.new( season.start_year, 7, 1 )
      end

     ## todo/fix:  use first date found as divider / start!!!!!
     ##  why - why not?

    auto_conf_teams, _ = SportDb::AutoConfParser.parse( lines,
                                                       start: start )
    pp auto_conf_teams


    matches, _ = SportDb::MatchParser.parse( lines,
                                              auto_conf_teams.keys,
                                             start: start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)


    puts "#{matches.size} matches:"

    matches

  ## (re)sort by 1) date and 2) matchday
  matches = matches.sort do |l,r|
    res =  l.date  <=> r.date    ## oldest first
    res =  round_to_i( l.round) <=> round_to_i( r.round )  if res == 0
    res
  end

  # pp matches

  puts "#{matches.size} matches"
  matches
end







def reformat( path )
  secs = read_secs( path )
  pp secs

  if secs.size < 1
    puts "!! ERROR: got #{secs.size} sections(s); expected 1 or greater:"
    pp secs
    exit 1
  end


  buf = String.new('')

  puts "#{secs.size} sections(s):"
  secs.each do |sec|
    league_q = sec[:league]
    season_q = sec[:season]
    stage_q  = sec[:stage]
    lines    = sec[:lines]

    puts "== #{league_q} | #{season_q}"
    matches = read_matches( lines, season: season_q )
    pp matches

    more_buf = SportDb::TxtMatchWriter.build( matches,
              name: "#{league_q} #{season_q}" )
    buf << more_buf
    buf << "\n\n"
  end

  puts
  puts "=============================="
  puts buf

  File.open( path, 'w:utf-8' ) do |f|
    f.write( buf )
  end
end


# path = "../../../openfootball/england/2010-11/playoffs.txt"

DATAFILES = Dir["../../../openfootball/england/**/playoffs.txt"]

DATAFILES.each do |path|
  reformat( path )
end

pp DATAFILES