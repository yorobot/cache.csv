require_relative 'read'



TEAMS = {}

def check( league:, year: )

  path         = "./dl/competitions~~#{LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"
  path_teams   = "./dl/competitions~~#{LEAGUES[league.downcase]}~~teams-I-season~#{year}.json"

  data         = read_json( path )
  data_teams   = read_json( path_teams )

  ## build a (reverse) team lookup by name
  puts "#{data_teams['teams'].size} teams"

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
                                 country: teams_by_name[ team ]['area']['name'],
                                 address: teams_by_name[ team ]['address'],
                               }
       rec[ :count ] += 1
    end # each team

  end # each match

end # method check



DATASETS = [
            ['CL',    %w[2018 2019]],
           ]

pp DATASETS

DATASETS.each do |dataset|
  basename = dataset[0]
  dataset[1].each do |year|
    check( league: basename, year: year )
  end
end

pp TEAMS




require_relative '../boot'

mods = SportDb::Import.catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                    'Barcelona'                => 'FC Barcelona, ESP',
                    'Valencia'                 => 'Valencia CF, ESP'  })

## pp mods



#######################
# check and normalize team names

TEAMS.each do |team_name, team_hash|

   country_name = team_hash[ :country ]
   ### FIX!!! - addd FYR to footballdb countries!!!!
   country_name = 'North Macedonia'   if country_name = 'FYR Macedonia'

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
    puts "#{team_name} => #{club.name}"  if team_name != club.name
   end
end

puts "bye"

