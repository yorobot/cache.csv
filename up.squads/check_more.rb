require_relative 'helper'   ## (shared) boot helper


SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"





def check_league(    league:,
                     season: )
                     
league_page = Footballsquads.league( league: league, season: season )
pp league_page.title

## find league rec
leagues = SportDb::Import.catalog.leagues
league_rec   = leagues.find!( league )


league_page.each_team do |team_page|
   # pp team_page.title

   team_name         =  team_page.team_name
   # pp team_name
   team_name_official = team_page.team_name_official
   # pp team_name_official

##
#  map team name
#  
    # try short name first
    clubs =  SportDb::Import.catalog.clubs

    m1 = clubs.match_by( name: team_name,           country: league_rec.country.key )
    m2 = clubs.match_by( name: team_name_official,  country: league_rec.country.key )

   team_name_short =  
    if m1.size == 1 && m2.size == 1
       puts "OK  #{team_name}  -  #{team_name_official}  =>  #{m1[0].name}"

       m1[0].name   ## use "canonical name"
    else
      ## report 
      if m1.size == 0 && m2.size == 0
        puts
        puts "!!  no match for team in  #{league_rec.country.name} - #{league_rec.name}:"
        puts "    #{team_name}"
        puts "    #{team_name_official}"
     else
        puts "!!  missing match for team in  #{league_rec.country.name} - #{league_rec.name}:"
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

        ## use org name  with official name as comment
        ##   -- log warning!! to errors.txt or logs.txt or such!!!
        "#{team_name_official}    # #{team_name}"
    end
  end


  puts team_page.team_info   ## formed, ground, manager
  puts 
end
end  # method check_league




DATASETS = [
  ['eng.1',   %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['eng.2',   %w[2023/24 2022/23 2021/22 2020/21]],
  ['eng.3',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['es.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['es.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['de.1',    %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['de.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['sco.1',  %w[2023/24 2022/23 2021/22 2020/21]], 

  ['it.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['it.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['fr.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['fr.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['pt.1',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['nl.1',   %w[2023/24 2022/23 2021/22 2020/21]],
  ['be.1',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['tr.1',  %w[2023/24 2022/23 2021/22 2020/21]],
  ['gr.1',  %w[2023/24 2022/23 2021/22 2020/21]],

  ['ru.1',  %w[2023/24 2022/23 2021/22 2020/21]],
  ['ua.1', %w[2023/24 2022/23 2021/22 2020/21]],
  ['pl.1',  %w[2023/24 2022/23 2021/22 2020/21]],

  ['dk.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['at.1',    %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['ch.1',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['cz.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['hr.1',    %w[2023/24 2022/23]],
  ['hu.1',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['no.1',    %w[2024 2023 2022 2021]],
  ['se.1',    %w[2024 2023 2022 2021]],

 # ['ie.1',    %w[2024 2023 2022 2021]],
]



pp DATASETS

datasets = DATASETS

Webcache.root = '../../../cache'  ### c:\sports\cache
pp Webcache.root


datasets.each_with_index do |(league_key, seasons),i|
 
  seasons.each_with_index do |season_key,j|  
    season   =  Season( season_key )

    puts "==> [#{i+1}/#{datasets.size}]  #{league_key} #{season_key} [#{j+1}/#{seasons.size}]..."

    check_league( league: league_key, 
                    season: season_key )
  end
end



puts "bye"

