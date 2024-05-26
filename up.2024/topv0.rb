
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

    stats = {}

    ## todo/fix: cache name lookups - why? why not?
    puts "==> normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|        
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       if match.team1 != team1.name
          stat = stats[ match.team1 ] ||= Hash.new(0)
          stat[ team1.name ] += 1
       end   

       if match.team2 != team2.name
          stat = stats[ match.team2 ] ||= Hash.new(0)
          stat[ team2.name ] += 1
       end
   
       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
   
    if stats.size > 0
      pp stats
    end

    print "norm OK\n"

    matches
  end




$LOAD_PATH.unshift( '../../sport.db.more/sportdb-writers/lib' )
require 'sportdb/writers'



source_dir = '../../../stage'

SEASONS = ['2023/24',
           '2022/23',
           '2021/22',
           '2020/21'
          ]

leagues = {
   'eng.1' => {  name:   'English Premier League',
                 lang:   'en',
                 slug:   '1-premierleague',
                 seasons: SEASONS,
              },
   'de.1'  => {  name:  'Deutsche Bundesliga',
                 lang:   'de_DE',
                 slug:   '1-bundesliga',
                 seasons: SEASONS,
              },
   'es.1'   => { name:  'Primera División de España',
                 lang:   'es',
                 slug:   '1-liga',
                 seasons: SEASONS,
               },  
   'fr.1'   => { name:  'French Ligue 1',
                 lang:   'fr',
                 slug:   '1-ligue1',
                 seasons: SEASONS,
               },                    
   'it.1'   => { name:  'Italian Serie A',
                 lang:   'it',
                 slug:   '1-seriea',
                 seasons: SEASONS,
               },                    
}



leagues.each_with_index do |(league, config),i|
  lang    = config[:lang] || 'en'
  name    = config[:name] 
  slug    = config[:slug]
  seasons = config[:seasons]

  seasons.each_with_index do |season,j|
    season = Season( season )   ## convert to Season obj

    matches = SportDb::CsvMatchParser.read( 
                 "#{source_dir}/#{season.to_path}/#{league}.csv" )

    puts "==> [#{i+1}/#{leagues.size}]  #{name} #{season.key} [#{j+1}/#{seasons.size}]  -  #{matches.size} match(es)..."

    # puts
    # pp matches[0]
    # puts
    # pp matches[-1]
             
    matches = normalize( matches, league: league )
              
    SportDb::TxtMatchWriter.write( "./o/#{season.to_path}/#{slug}.txt", 
                                   matches,
                                   name: "#{name} #{season.key}",
                                   lang:  lang ) 
  end
end


puts "bye"