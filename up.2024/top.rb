
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
      res =   l.time <=> r.time     if res == 0 && l.time && r.time
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

def write_txt( path, matches,
           league:,
           season:,
           lang: )

  puts
  pp matches[0]
  puts
  pp matches[-1]
  puts "#{matches.size} matches"

  matches = normalize( matches, league: league )
 
  SportDb::TxtMatchWriter.write( path, matches,
                             name: "#{league} #{season}",
                             lang:  lang )
end




$LOAD_PATH.unshift( '../../sport.db.more/sportdb-writers/lib' )
require 'sportdb/writers'

#######
# try eng.1


source_dir = '../../../stage'

seasons = ['2023/24',
           '2022/23',
           '2021/22',
           '2020/21'
          ]

seasons.each do |season|
  season = Season( season )   ## convert to Season obj

  matches = SportDb::CsvMatchParser.read( 
                 "#{source_dir}/#{season.to_path}/eng.1.csv" )

  write_txt( "./o/#{season.to_path}/pl.txt", 
             matches, 
             league: 'English Premier League',
             season: season.key,
             lang: 'en' )
end


#######
# try de.1
seasons.each do |season|
  season = Season( season )   ## convert to Season obj

  matches = SportDb::CsvMatchParser.read( 
                 "#{source_dir}/#{season.to_path}/de.1.csv" )

  write_txt( "./o/#{season.to_path}/bl.txt", 
              matches, 
              league: 'Deutsche Bundesliga',
              season: '2023/24',
              lang: 'de' )
end


puts "bye"