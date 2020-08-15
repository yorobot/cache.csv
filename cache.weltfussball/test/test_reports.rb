
require_relative '../lib/metal'


## get all reports for a (schedule) page
# path = './dl/at.2-2019-20.html'
# path = './dl/at.1-2014-15.html'
# path = './dl/at.1-2016-17.html'
path = './dl/eng.1-2019-20.html'

page = Worldfootball::Page::Schedule.from_file( path )
rows = page.matches

puts "matches - #{rows.size} rows:"
pp rows[0]

puts page.generated


Worldfootball.config.sleep = 10    ## fetch 6 pages/min


matches_count = page.matches.size
page.matches.each_with_index do |match,i|
   est = (Worldfootball.config.sleep * (matches_count-(i+1)))/60.0 # estimated time left
   puts "fetching #{i+1}/#{matches_count} (#{est} min(s)) - #{match[:round]} | #{match[:team1][:text]} v #{match[:team2][:text]}..."
   Worldfootball.report( match[:report ] )
end

puts "bye"
