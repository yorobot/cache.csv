require 'pp'

require_relative '../config'


puts "mx.1:"
pp Worldfootball::LEAGUES['mx.1']

puts "be.1:"
pp Worldfootball::LEAGUES['be.1']

puts "eng.3:"
pp Worldfootball::LEAGUES['eng.3']


puts "---"
pp Worldfootball::LEAGUES


puts "at.1:"
at1 = Worldfootball.find_league( 'at.1' )
pp at1

puts "mx.1:"
pp Worldfootball.find_league( 'mx.1' )

puts "be.1:"
pp Worldfootball.find_league( 'be.1' )

puts "eng.3:"
pp Worldfootball.find_league( 'eng.3' )


puts
puts "pages:"
pp Worldfootball::PAGES