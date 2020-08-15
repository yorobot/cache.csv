require_relative '../lib/convert'



puts
puts "at.1:"
at1 = Worldfootball.find_league( 'at.1' )
pp at1

pp at1.pages( season: Season('2019/20') )
pp at1.pages( season: Season('2018/19') )


puts
puts "at.2:"
at2 = Worldfootball.find_league( 'at.2' )
pp at2

pp at2.pages( season: Season('2019/20') )
pp at2.pages( season: Season('2018/19') )
pp at2.pages( season: Season('2017/18') )

puts
puts "pl.1:"
pl1 = Worldfootball.find_league( 'pl.1' )
pp pl1

pp pl1.pages( season: Season('2020/21') )
pp pl1.pages( season: Season('2019/20') )
pp pl1.pages( season: Season('2018/19') )

# pp pl1.pages( season: Season('2015/6') )
# => !! ERROR - no configuration found for season >2015/16< for league >pl.1< found; sorry


