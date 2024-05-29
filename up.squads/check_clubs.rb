require_relative 'helper'   ## (shared) boot helper


SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"





DATASETS_TOP = [
  ['eng.1',   %w[2023/24]],
  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],

  ['at.1',    %w[2023/24]],
]


# try some more
DATASETS_MORE = [
#  ['sco.1',  %w[2023/24]], 
#  ['pt.1',  %w[2023/24]],
#  ['nl.1',   %w[2023/24]],

#  ['be.1',  %w[2023/24]],
  ['tr.1',  %w[2023/24]],
  ['gr.1',  %w[2023/24]],

  ['ru.1',  %w[2023/24]],
  ['ua.1', %w[2023/24]],
  ['pl.1',  %w[2023/24]],

  ['br.1',  %w[2024]],
  ['ar.1',  %w[2024]], 
  
  ['eng.2',   %w[2023/24]],
  ['eng.3',   %w[2023/24]],
  ['de.2',    %w[2023/24]],
  ['es.2',    %w[2023/24]],
  ['fr.2',    %w[2023/24]],
  ['it.2',    %w[2023/24]],

]

datasets = DATASETS_TOP
pp datasets



Webcache.root = '../../../cache'  ### c:\sports\cache
pp Webcache.root


leagues = SportDb::Import.catalog.leagues
clubs   = SportDb::Import.catalog.clubs



datasets.each_with_index do |(league_key, seasons),i|
  
  league = leagues.find!( league_key )

  seasons.each_with_index do |season_key,j|  
    season   =  Season( season_key )
 
    puts "==> [#{i+1}/#{datasets.size}]  #{league_key} #{season_key} [#{j+1}/#{seasons.size}]..."

    league_page = Footballsquads.league( league: league_key, season: season_key )
    pp league_page.title

    league_page.each_team do |team_page|
      # pp team_page.title
      team_name         =  team_page.team_name
      # pp team_name
      team_name_official = team_page.team_name_official
      # pp team_name_official

      country_key = league.country.key
      
      # try short name first
      m1 = clubs.match_by( name: team_name,           country: country_key )
      m2 = clubs.match_by( name: team_name_official,  country: country_key )
 
    if m1.size == 1 && m2.size == 1
       puts "OK  #{team_name}  -  #{team_name_official}  =>  #{m1[0].name}"
    else
       if m1.size == 0 && m2.size == 0
          puts
          puts "!!  no match for team in  #{league.country.name} - #{league.name}:"
          puts "    #{team_name}"
          puts "    #{team_name_official}"
       else
          puts "!!  missing match for team in  #{league.country.name} - #{league.name}:"
          if m1.size == 0
              puts "   !!  #{team_name}"
          elsif m1.size == 1
              puts "   OK  #{team_name}"
          else
              puts "   !!  #{team_name}  - too many matches - #{m1.size}:"
              pp m1
          end
          if m2.size == 0
            puts "   !!  #{team_name_official}"
          elsif m2.size == 1
            puts "   OK  #{team_name_official}"
          else
            puts "   !!  #{team_name_official}  - too many matches - #{m2.size}:"
            pp m2
          end
     end
    end


    end
  end
end


puts "bye"

