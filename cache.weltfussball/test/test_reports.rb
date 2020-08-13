
require_relative '../lib/metal'


## get all reports for a (schedule) page
path = './dl/at.2-2019-20.html'

page = Worldfootball::Page::Schedule.from_file( path )
rows = page.matches

puts "matches - #{rows.size} rows:"
pp rows[0]

puts page.generated


Worldfootball.config.sleep = 10    ## fetch 6 pages/min


page.matches.each_with_index do |match,i|
   puts "fetching #{i+1}/#{page.matches.size} - #{match[:round]} | #{match[:team1][:text]} v #{match[:team2][:text]}..."
   Worldfootball.report( match[:report ] )
end

puts "bye"
