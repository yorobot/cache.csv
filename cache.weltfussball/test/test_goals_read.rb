require_relative '../lib/convert'



path = './tmp/goals.at.2014-15.csv'
recs = read_csv( path )
puts "goals - #{recs.size} records"

pp recs[0]

recs = recs.map { |rec| SportDb::Import::GoalEvent.build( rec ) }
pp recs[0]



goals_by_match = recs.group_by { |rec| rec.match_id }
puts "match goal reports - #{goals_by_match.size} records"
goals_by_match.each_with_index do |(match_id, recs),i|

  puts "#{match_id} - #{recs.size} goals / records:"

  goals = SportDb::Import::Goal.build( recs )

  next if i > 3

  pp recs
  pp goals
end



puts "bye"