require_relative '../boot'


########
# helpers
#   normalize team names
def normalize( matches, league: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)
      res =   l.date <=> r.date
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = SportDb::Import.catalog.leagues.find!( league )
    country = league.country

    ## todo/fix: cache name lookups - why? why not?
    matches.each do |match|
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       puts "#{match.team1} => #{team1.name}"  if match.team1 != team1.name
       puts "#{match.team2} => #{team2.name}"  if match.team2 != team2.name

       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
    matches
end





##########
# start

def write_eng( season, source: nil, extra: nil )
  season = SportDb::Import::Season.new( season )  ## normalize season

  in_path = if source == 'leagues'
              "../cache.leagues/o/#{season.path}/eng.1.csv"
            else
              "../../stage/one/#{season.path}/eng.1.csv"
            end

  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"

  league_name  = 'English Premier League'

  matches = normalize( matches, league: league_name )

  season_path = String.new('')    ## note: allow extra path for output!!!! e.g. archive/2000s etc.
  season_path << "#{extra}/"   if extra
  season_path << season.path

  out_path = "../../../openfootball/england/#{season_path}/1-premierleague.txt"
  SportDb::TxtMatchWriter.write( out_path, matches,
                               name: "#{league_name} #{season.key}",
                               round: 'Matchday',
                               lang:  'en')
end


def write_es( season, source: nil )
## todo/fix:
## extras - add more info
## 2018/19
##   Jornada 6 /  Sevilla FC - Real Madrid
##      [André Silva 17', 21' Wissam Ben Yedder 39']

    season = SportDb::Import::Season.new( season )  ## normalize season

    in_path = if source == 'leagues'
      "../cache.leagues/o/#{season.path}/es.1.csv"
    else
      "../../stage/one/#{season.path}/es.1.csv"
    end

    matches = SportDb::CsvMatchParser.read( in_path )

    pp matches[0]
    puts "#{matches.size} matches"

    league_name  = 'Primera División de España'

    matches = normalize( matches, league: league_name )

    out_path = "../../../openfootball/espana/#{season.path}/1-liga.txt"
    SportDb::TxtMatchWriter.write( out_path, matches,
                            name: "#{league_name} #{season.key}",
                            round: 'Jornada',
                            lang:  'es')
end

def write_es2( season )
      season = SportDb::Import::Season.new( season )  ## normalize season

      in_path = "../cache.leagues/o/#{season.path}/es.2.csv"

      matches = SportDb::CsvMatchParser.read( in_path )

      pp matches[0]
      puts "#{matches.size} matches"

      league_name  = 'Segunda División de España'

      matches = normalize( matches, league: league_name )

      out_path = "../../../openfootball/espana/#{season.path}/2-liga2.txt"
      SportDb::TxtMatchWriter.write( out_path, matches,
                              name: "#{league_name} #{season.key}",
                              round: 'Jornada',
                              lang:  'es')
end


def write_fr( season )
      season = SportDb::Import::Season.new( season )  ## normalize season

      in_path = "../cache.leagues/o/#{season.path}/fr.1.csv"

      matches = SportDb::CsvMatchParser.read( in_path )

      pp matches[0]
      puts "#{matches.size} matches"

      league_name  = 'French Ligue 1'

      matches = normalize( matches, league: league_name )

      out_path = "../../../openfootball/france/#{season.path}/1-ligue1.txt"
      SportDb::TxtMatchWriter.write( out_path, matches,
                              name: "#{league_name} #{season.key}",
                              round: 'Journée',
                              lang:  'fr')
  end

  def write_fr2( season )
        season = SportDb::Import::Season.new( season )  ## normalize season

        in_path = "../cache.leagues/o/#{season.path}/fr.2.csv"

        matches = SportDb::CsvMatchParser.read( in_path )

        pp matches[0]
        puts "#{matches.size} matches"

        league_name  = 'French Ligue 2'

        matches = normalize( matches, league: league_name )

        out_path = "../../../openfootball/france/#{season.path}/2-ligue2.txt"
        SportDb::TxtMatchWriter.write( out_path, matches,
                                name: "#{league_name} #{season.key}",
                                round: 'Journée',
                                lang:  'fr')
  end




def write_it( season, source: nil )
    season = SportDb::Import::Season.new( season )  ## normalize season

    in_path = if source == 'leagues'
                "../cache.leagues/o/#{season.path}/it.1.csv"
              else
                "../../stage/one/#{season.path}/it.1.csv"
              end

    matches = SportDb::CsvMatchParser.read( in_path )

    pp matches[0]
    puts "#{matches.size} matches"

    league_name  = 'Italian Serie A'

    matches = normalize( matches, league: league_name )

    out_path = "../../../openfootball/italy/#{season.path}/1-seriea.txt"
    SportDb::TxtMatchWriter.write( out_path, matches,
                            name: "#{league_name} #{season.key}",
                            round: ->(round) { "%s^ Giornata" % round },
                            lang:  'it')
end



def write_matches( path, matches, name:, lang: )
  round = if lang == 'de'
            'Spieltag'
          else
            puts "!! ERROR - unsupported lang >#{lang}<in write_matches"
            exit 1
          end

  SportDb::TxtMatchWriter.write( path, matches,
                                  name:  name,
                                  round: round,
                                  lang:  lang )
end


def split_matches( matches, season: )
  matches_i  = []
  matches_ii = []
  matches.each do |match|
    date = Date.strptime( match.date, '%Y-%m-%d' )
    if date.year == season.start_year
      matches_i << match
    elsif date.year == season.end_year
      matches_ii << match
    else
      puts "!! ERROR: match date-out-of-range for season:"
      pp season
      pp date
      pp match
      exit 1
    end
  end
  [matches_i, matches_ii]
end


def write_worker_de( matches, season:, league_name:, basename:, split: )
  pp matches[0]
  puts "#{matches.size} matches"

  matches = normalize( matches, league: league_name )

  if split
    matches_i, matches_ii = split_matches( matches, season: season )

    path = "../../../openfootball/deutschland/#{season.path}/#{basename}-i.txt"
    write_matches( path, matches_i, name: "#{league_name} #{season.key}",
                                        lang:  'de' )
    path = "../../../openfootball/deutschland/#{season.path}/#{basename}-ii.txt"
    write_matches( path, matches_ii, name: "#{league_name} #{season.key}",
                                        lang:  'de' )
  else
    path = "../../../openfootball/deutschland/#{season.path}/#{basename}.txt"
    write_matches( path, matches, name: "#{league_name} #{season.key}",
                                      lang:  'de' )
  end
end


def write_de( season, split: false )
  season = SportDb::Import::Season.new( season )  ## normalize season

  path = "../cache.leagues/o/#{season.path}/de.1.csv"

  matches = SportDb::CsvMatchParser.read( path )

  write_worker_de( matches,
                   season: season,
                   league_name: 'Deutsche Bundesliga',
                   basename: '1-bundesliga',
                   split: split )
end

def write_de2( season, split: false )
      season = SportDb::Import::Season.new( season )  ## normalize season

      path = "../cache.leagues/o/#{season.path}/de.2.csv"

      matches = SportDb::CsvMatchParser.read( path )

      write_worker_de( matches,
                       season: season,
                       league_name: 'Deutsche 2. Bundesliga',
                       basename: '2-bundesliga2',
                       split: split )
  end

  def write_de3( season, split: false )
        season = SportDb::Import::Season.new( season )  ## normalize season

        path = "../cache.leagues/o/#{season.path}/de.3.csv"

        matches = SportDb::CsvMatchParser.read( path )

        write_worker_de( matches,
                         season: season,
                         league_name: 'Deutsche 3. Liga',
                         basename: '3-liga3',
                         split: split )
  end

write_de( '2010-11' )
write_de( '2011-12' )
write_de( '2012-13', split: true )
write_de( '2013-14', split: true )

write_de( '2014-15', split: true )
write_de2( '2014-15', split: true )
write_de3( '2014-15', split: true )

write_de( '2015-16', split: true )
write_de2( '2015-16', split: true )
write_de3( '2015-16', split: true )

write_de( '2016-17', split: true )
write_de2( '2016-17', split: true )
write_de3( '2016-17', split: true )

write_de( '2017-18', split: true )
write_de2( '2017-18', split: true )
write_de3( '2017-18', split: true )

# write_de2( '2019/20' )
# write_de3( '2019/20' )

# write_de2( '2018/19' )
# write_de3( '2018/19' )


# write_eng( '1992/93', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1993/94', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1994/95', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1995/96', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1996/97', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1997/98', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '2000/01', source: 'leagues', extra: 'archive/2000s')

# write_eng( '2001/02', source: 'leagues', extra: 'archive/2000s')
# write_eng( '2002/03', source: 'leagues', extra: 'archive/2000s')
# write_eng( '2003/04', source: 'leagues', extra: 'archive/2000s')


# write_eng( '2010/11', source: 'leagues' )
# write_eng( '2011/12', source: 'leagues' )
# write_eng( '2012/13', source: 'leagues' )
# write_eng( '2013/14', source: 'leagues' )
# write_eng( '2014/15', source: 'leagues' )
# write_eng( '2015/16', source: 'leagues' )
# write_eng( '2016/17', source: 'leagues' )
# write_eng( '2017/18', source: 'leagues' )

# write_eng( '2018/19' )
# write_eng( '2019/20' )

# write_es( '2012/13', source: 'leagues' )
# write_es( '2013/14', source: 'leagues' )
# write_es( '2014/15', source: 'leagues' )
# write_es( '2015/16', source: 'leagues' )
# write_es( '2016/17', source: 'leagues' )
# write_es( '2017/18', source: 'leagues' )
# write_es( '2018/19', source: 'leagues' )
# write_es( '2019/20' )
# write_es2( '2019/20' )

# write_fr( '2014/15' )
# write_fr2( '2014/15' )
# write_fr( '2015/16' )
# write_fr( '2016/17' )
# write_fr( '2017/18' )
# write_fr( '2018/19' )
# write_fr( '2019/20' )


# write_it( '2019/20' )

# write_it( '2013/14', source: 'leagues' )
# write_it( '2014/15', source: 'leagues' )
# write_it( '2015/16', source: 'leagues' )
# write_it( '2016/17', source: 'leagues' )
# write_it( '2017/18', source: 'leagues' )
# write_it( '2018/19', source: 'leagues' )


puts "bye"