require 'csvreader'


## about 2 MiBs (Megas)
path = '../../../schochastics/football-data/data/results/austria.csv'

=begin
{:home=>"Austria Wien",
 :away=>"FC Wien",
 :date=>"1945-09-01",
 :gh=>"10",
 :ga=>"2",
 :full_time=>"F",
 :competition=>"austria",
 :home_ident=>"Austria Wien (Austria)",
 :away_ident=>"FC Wien (Austria)",
 :home_country=>"austria",
 :away_country=>"austria",
 :home_code=>"AT",
 :away_code=>"AT",
 :home_continent=>"Europe",
 :away_continent=>"Europe",
 :continent=>"Europe",
 :level=>"national"}

{:full_time=>{"F"=>13573},
 :competition=>{"austria"=>13573},
 :country=>{"austria"=>27146},
 :code=>{"AT"=>27146},
 :continent=>{"Europe"=>13573},
 :level=>{"national"=>13573}}
=end



columns = {}

i = 0
CsvHash.foreach( path, :header_converters => :symbol  ) do |row|
  i += 1

  pp row  if i == 1

  print '.' if i % 100 == 0


  if "#{row[:home]} (Austria)" != row[:home_ident]
    puts "!! #{row[:home]} != #{row[:home_ident]}"
  end

  if "#{row[:away]} (Austria)" != row[:away_ident]
    puts "!! #{row[:away]} != #{row[:away_ident]}"
  end



  column = columns[ :full_time] ||= Hash.new(0)
  column[ row[:full_time] ] += 1

  column = columns[ :competition] ||= Hash.new(0)
  column[ row[:competition] ] += 1

  column = columns[ :country] ||= Hash.new(0)
  column[ row[:home_country] ] += 1
  column[ row[:away_country] ] += 1

  column = columns[ :code] ||= Hash.new(0)
  column[ row[:home_code] ] += 1
  column[ row[:away_code] ] += 1

  column = columns[ :continent] ||= Hash.new(0)
  column[ row[:continent] ] += 1

  column = columns[ :level] ||= Hash.new(0)
  column[ row[:level] ] += 1
end

puts
puts
pp columns

puts "bye"

