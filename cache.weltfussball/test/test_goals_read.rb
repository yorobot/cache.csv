require_relative '../lib/convert'



def merge_goals( matches, goals )
  goals_by_match = goals.group_by { |rec| rec.match_id }
  puts "match goal reports - #{goals_by_match.size} records"

  ## lets group by date for easier lookup
  matches_by_date = matches.group_by { |rec| rec.date }


  ## note: "shadow / reuse" matches and goals vars for now in loop
  ##  find better names to avoid confusion!!
  goals_by_match.each_with_index do |(match_id, goals),i|
    ## split match_id
    team_str, more_str   = match_id.split( '|' )
    team1_str, team2_str = team_str.split( ' - ' )

    more_str  = more_str.strip
    team1_str = team1_str.strip
    team2_str = team2_str.strip

    ## for now assume date in more (and not round or something else)
    date_str = more_str  # e.g. in 2019-07-26 format

    puts ">#{team1_str}< - >#{team2_str}< | #{date_str},    #{goals.size} goals"

    ## try a join - find matching match
    matches = matches_by_date[ date_str ]
    if matches.nil?
      puts "!! ERROR: no match found for date >#{date_str}<"
      exit 1
    end

    found_matches = matches.select {|match| match.team1 == team1_str &&
                                            match.team2 == team2_str }

    if found_matches.size == 1
      match = found_matches[0]
      match.goals = SportDb::Import::Goal.build( goals )
    else
      puts "!!! ERROR: found #{found_matches.size} in #{matches.size} matches for date >#{date_str}<:"
      matches.each do |match|
        puts "  >#{match.team1}< - >#{match.team2}<"
      end
    end
  end
end


path = './o/2019-20/at.2.csv'
matches = Sports::CsvMatchParser.read( path )
puts "matches - #{matches.size} records"
pp matches[0]

path = './tmp/goals.csv'
goals = Sports::CsvGoalParser.read( path )
puts "goals - #{goals.size} records"
pp goals[0]


puts
puts "merge goals:"
merge_goals( matches, goals )
pp matches[0]
pp matches[-1]



puts
puts "bye"


__END__

puts
puts "GoalEvent date type is:"
puts recs[0].date.class.name
# GoalEvent date type is:
# Date

puts
puts "match.date type is:"
puts matches[0].date.class.name  ## check date type
# match.date type is:
# String
## todo/fix. change date type to ALWAYS Date and NOT String!!!! why? why not?


first_date = matches_by_date.keys[0]  ## check first date
last_date  = matches_by_date.keys[-1]

## pp matches_by_date[ first_date ]
## pp matches_by_date[ last_date ]
