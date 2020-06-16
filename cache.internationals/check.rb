require 'csvreader'


## about 3 MiBs (Megas)
path = '../../martj42/international_results/results.csv'

#######################
#{:date=>"1872-11-30",
# :home_team=>"Scotland",
# :away_team=>"England",
# :home_score=>"0",
# :away_score=>"0",
# :tournament=>"Friendly",
# :city=>"Glasgow",
# :country=>"Scotland",
# :neutral=>"FALSE"}


tournaments = Hash.new(0)   ## track tournaments usage by records
teams       = Hash.new(0)

i = 0
CsvHash.foreach( path, :header_converters => :symbol  ) do |row|
  i += 1

  pp row  if i == 1

  print '.' if i % 100 == 0

  tournament = row[:tournament]
  team1      = row[:home_team]
  team2      = row[:away_team]

  tournaments[ tournament ] += 1

  teams[ team1 ] += 1
  teams[ team2 ] += 1

  # break if i > 1000
end


def dump( recs )
  recs.each do |rec|
    puts "%4d %s" % [rec[1], rec[0]]
  end
end


puts
puts

puts "tournaments:"
tournaments = tournaments.to_a.sort { |l,r| r[1] <=> l[1] }
dump( tournaments )

puts "teams:"
teams = teams.to_a.sort { |l,r| r[1] <=> l[1] }
dump( teams )




puts "bye"