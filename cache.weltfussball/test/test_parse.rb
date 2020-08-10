###
# test parse matches from page

require_relative '../lib/page'

# path = './dl/sco.1-2018-19-championship.html'
# path = './dl/de.cup-2012-13.html'
# path = './dl/ie.1-2020.html'
# path = './dl/nz.1-2019-20-regular.html'
path = './dl/lu.1-2019-20.html'

page = Worldfootball::Page.from_file( path )
rows = page.matches

puts "#{rows.size} rows:"
pp rows[0]

