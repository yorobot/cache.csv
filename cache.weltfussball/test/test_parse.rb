###
# test parse matches from page

require_relative '../lib/metal'

# slug = 'sco.1-2018-19-championship'
# slug = 'de.cup-2012-13'
# slug = 'ie.1-2020'
# slug = 'nz.1-2019-20-regular'
# slug = 'lu.1-2019-20'
# slug = 'tr.1-2019-20'
# slug = 'sco.1-2020-21-regular'
# slug = 'at.cup-2019-20'
slug = 'at.2-2019-20'

page = Worldfootball::Page::Schedule.from_cache( slug )
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