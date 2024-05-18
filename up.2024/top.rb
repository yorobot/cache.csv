
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/structs'   # incl. CsvMatchParser
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"


## more libs / gems


########
# helper
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
    puts "==> normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|        
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       puts "#{match.team1} => #{team1.name}"  if match.team1 != team1.name
       puts "#{match.team2} => #{team2.name}"  if match.team2 != team2.name

       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
    print "norm OK\n"

    matches
  end





$LOAD_PATH.unshift( '../../sport.db.more/sportdb-writers/lib' )
require 'sportdb/writers'

#######
# try eng.1

matches = SportDb::CsvMatchParser.read( '../../sport.db.more/football-sources/o/2023-24/eng.1.csv' )

puts
pp matches[0]
puts
pp matches[-1]
puts "#{matches.size} matches"



league_name  = 'English Premier League'
season_key   = '2023/24'


matches = normalize( matches, league: league_name )


     path = './o/2023-24/pl.txt'

  SportDb::TxtMatchWriter.write( path, matches,
                             name: "#{league_name} #{season_key}",
                             lang:  'en')

  

puts "bye"