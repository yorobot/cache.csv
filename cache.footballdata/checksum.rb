require_relative 'footballdata'


EVENTS  = SportDb::Import::EventIndex.build( "../../../openfootball/leagues" )
## SEASONS = SportDb::Import::SeasonIndex.new( EVENTS )






DATAFILES_DIR = "../../../footballcsv/cache.footballdata"


pack = SportDb::Package.new( DATAFILES_DIR )
pack.each_csv do |entry|
    league_q = File.basename( entry.name, File.extname( entry.name ))
    season_q  = File.basename( File.dirname (entry.name) )

    ## try mapping of league here - why? why not?
    league    = SportDb::Import.catalog.leagues.find!( league_q )
    season    = SportDb::Import::Season.new( season_q )  ## normalize season


    ## check if event info exits
    event = EVENTS.find_by( league: league, season: season )
    if event
      ## check if any counter is not nil/null
      if event.teams || event.matches || event.goals
        puts "  #{entry.name} => #{season.key} | #{league.name} (#{league.key})"

        matches    = SportDb::CsvMatchParser.parse( entry.read )
        matchlist  = SportDb::Import::Matchlist.new( matches )

        if event.teams
            team_count = matchlist.teams.count
            if event.teams == team_count
                puts "    OK  #{team_count} teams"
            else
                puts "!!  got #{team_count} teams; expected #{event.teams}"
            end
        end

        if event.matches
            match_count = matches.size
            if event.matches == match_count
                puts "    OK  #{match_count} matches"
            else
                puts "!!  got #{match_count} matches; expected #{event.matches}"
            end
        end

        if event.goals
            goal_count = matchlist.goals
            if event.goals == goal_count
                puts "    OK  #{goal_count} goals"
            else
                puts "!!  got #{goal_count} goals; expected #{event.goals}"
            end
        end
      end
    end
end

