###
# test parse matches from page

require_relative '../lib/metal'

# path = './dl/sco.1-2018-19-championship.html'
# path = './dl/de.cup-2012-13.html'
# path = './dl/ie.1-2020.html'
# path = './dl/nz.1-2019-20-regular.html'
# path = './dl/lu.1-2019-20.html'
# path = './dl/tr.1-2019-20.html'
# path = './dl/sco.1-2020-21-regular.html'
# path = './dl/at.cup-2019-20.html'
path = './dl/at.2-2019-20.html'

page = Worldfootball::Page::Schedule.from_file( path )
rows = page.matches

puts "matches - #{rows.size} rows:"
pp rows[0]

rows = page.teams
puts "teams - #{rows.size} rows:"
pp rows

rows = page.rounds
puts "rounds - #{rows.size} rows:"
pp rows

rows = page.seasons
puts "seasons - #{rows.size} rows:"
pp rows


puts page.generated

puts "bye"