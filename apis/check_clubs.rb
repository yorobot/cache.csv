
require 'cocos'

$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( '../../sport.db.more/webget-football/lib' )
require 'webget/football' 



pp Footballdata::LEAGUES
puts "  #{Footballdata::LEAGUES.keys.size} league(s)"

Webcache.root = '../../../cache'  ### c:\sports\cache

TEAMS = {}

def check( league:, year: )
  root = "#{Webcache.root}/api.football-data.org"
  path         = "#{root}/v4~~competitions~~#{Footballdata::LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"
  path_teams   = "#{root}/v4~~competitions~~#{Footballdata::LEAGUES[league.downcase]}~~teams-I-season~#{year}.json"

  data         = read_json( path )
  data_teams   = read_json( path_teams )

  ## build a (reverse) team lookup by name
  puts "==>  #{league} #{year} - #{data_teams['teams'].size} teams"

  teams_by_name = data_teams['teams'].reduce( {} ) do |h,rec|
     h[ rec['name'] ] = rec
     h
  end

  pp teams_by_name.keys


  matches = data[ 'matches']
  matches.each do |m|

    [m['homeTeam']['name'],
     m['awayTeam']['name']].each do |team|

       rec = TEAMS[ team ] ||= { count: 0,
                                 short:   teams_by_name[ team ]['shortName'],
                                 country: teams_by_name[ team ]['area']['name'],
                                 address: teams_by_name[ team ]['address'],
                               }
       rec[ :count ] += 1
    end # each team

  end # each match

end # method check


## ==>  uefa.cl 2022 - 79 teams
##      uefa.cl 2023 - 32 teams


DATASETS = [
            ['uefa.cl',    %w[2020 2021 2022 2023]],
           ]

pp DATASETS


DATASETS.each do |dataset|
  basename = dataset[0]
  dataset[1].each do |year|
    check( league: basename, year: year )
  end
end

pp TEAMS




$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"


mods = SportDb::Import.catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                    'Barcelona'                => 'FC Barcelona, ESP',
                    'Valencia'                 => 'Valencia CF, ESP'  })

pp mods



puts
puts "==> #{TEAMS.keys.size} teams"


#######################
# check and normalize team names

TEAMS.each_with_index do |(team_name, team_hash),i|

   country_name = team_hash[ :country ]
  

   country = SportDb::Import.catalog.countries.find( country_name )
   if country.nil?
     puts "!! ERROR: no mapping found for country >#{country_name}<:"
     pp team_name
     pp team_hash
     exit 1
   end


   ## note: first check mods!!! e.g. Liverpool
   club = mods[ team_name ] || SportDb::Import.catalog.clubs.find( team_name )
   if club.nil?
    puts "!! ERROR: no mapping found for club >#{team_name}<:"
    pp team_hash
    ## exit 1
   else
    if team_name != club.name
       puts "!! #{i} -   #{team_name} | #{team_hash[:short]}  =>  #{club.name}"  
       puts  "             @ #{team_hash[:address]} > #{team_hash[:country]}"
    else
      puts "    #{i} -   #{team_name}"
    end 
   end
end

puts "bye"

