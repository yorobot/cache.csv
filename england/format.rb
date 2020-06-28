###
#  (re)format datafile

require '../boot'


OUT_DIR='../../../openfootball/england'
# OUT_DIR='./o'



def read_matches( path )
  secs = SportDb::LeagueOutlineReader.read( path )

  if secs.size != 1
    puts "!! ERROR: got #{secs.size} sections(s); expected 1:"
    pp secs
    exit 1
  end

  sec = secs[0]
  ## pp sec

  season = sec[:season]
  league = sec[:league]
  stage  = sec[:stage]
  lines  = sec[:lines]

  start = if season.year?
            Date.new( season.start_year, 1, 1 )
          else
            Date.new( season.start_year, 7, 1 )
          end

  auto_conf_teams, _ = SportDb::AutoConfParser.parse( lines,
                                                    start: start )
  pp auto_conf_teams


  matches, _ = SportDb::MatchParser.parse( lines,
                                            auto_conf_teams.keys,
                                            start: start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)


  puts "#{matches.size} matches:"


  ## convert rounds / matchday to integer from string
  ##   e.g. "Matchday 1"  => 1
  matches = matches.map do |match|
    if match.round =~ /\bMatchday (\d+)\b/
      match.update( round: $1.to_i )
    else
      puts "!! ERROR - expected matchday in match.round:"
      pp match
      exit 1
    end
    match
  end

  ## (re)sort by 1) date and 2) matchday
  matches = matches.sort do |l,r|
    res =  l.date  <=> r.date    ## oldest first
    res =  l.round <=> r.round   if res == 0
    res
  end

  # pp matches

  puts "#{matches.size} matches"
  matches
end


def write_eng1( season_q )
    season = SportDb::Import::Season.new( season_q )
    in_path = "../../../openfootball/england/#{season.path}/1-premierleague.txt"

    matches = read_matches( in_path )

    league_name  = 'English Premier League'

   out_path = "#{OUT_DIR}/#{season.path}/1-premierleague.txt"
   SportDb::TxtMatchWriter.write( out_path, matches,
                             title: "#{league_name} #{season.key}",
                             round: 'Matchday',
                             lang:  'en')
end

def write_eng2( season_q )
    season = SportDb::Import::Season.new( season_q )
    in_path = "../../../openfootball/england/#{season.path}/2-championship.txt"

    matches = read_matches( in_path )

    league_name  = 'English Championship'

   out_path = "#{OUT_DIR}/#{season.path}/2-championship.txt"
   SportDb::TxtMatchWriter.write( out_path, matches,
                             title: "#{league_name} #{season.key}",
                             round: 'Matchday',
                             lang:  'en')
end



write_eng1( '2010/11' )
write_eng1( '2011/12' )

write_eng2( '2010/11' )
write_eng2( '2011/12' )
