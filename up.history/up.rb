require_relative 'helper'


Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'

Worldfootball.config.convert.out_dir     = './o'


# league  = 'mx.1'
league = 'ro.1'
seasons = Season('2010/11')..Season('2019/20')


### convert
seasons.each do |season|
  puts "#{league} #{season}:"

  Worldfootball.convert( league: league,
                         season: season,
                         offset: Worldfootball::OFFSETS[ league ] )

end

__END__

### write

#  Writer.config.out_dir = "#{SportDb::Boot.root}/openfootball"
Writer.config.out_dir = './tmp'

seasons.each do |season|
  puts "#{league} #{season}:"

  Writer.write( league, season,
                source: Worldfootball.config.convert.out_dir )
end



puts "bye"
