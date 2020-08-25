require_relative 'helper'


## top 5

####################
## download pages

def dl_2019_20
  Worldfootball.schedule( league: 'es.1', season: '2019/20' )
  Worldfootball.schedule_reports( league: 'es.1', season: '2019/20' )

  Worldfootball.schedule( league: 'it.1', season: '2019/20' )
  Worldfootball.schedule_reports( league: 'it.1', season: '2019/20' )

  Worldfootball.schedule( league: 'fr.1', season: '2019/20' )
  Worldfootball.schedule_reports( league: 'fr.1', season: '2019/20' )
end

def dl_2020_21
  Worldfootball.schedule( league: 'eng.1', season: '2020/21' )
  Worldfootball.schedule( league: 'de.1',  season: '2020/21' )
  Worldfootball.schedule( league: 'fr.1',  season: '2020/21' )
end



#################
## convert (cached) pages

# Worldfootball.config.convert.out_dir = './o/aug25'
Worldfootball.config.convert.out_dir = './o'


Worldfootball.convert( league: 'eng.1', season: '2020/21' )
Worldfootball.convert( league: 'de.1',  season: '2020/21' )
Worldfootball.convert( league: 'fr.1',  season: '2020/21' )


Worldfootball.convert( league: 'es.1', season: '2019/20' )
Worldfootball.convert( league: 'it.1', season: '2019/20' )
Worldfootball.convert( league: 'fr.1', season: '2019/20' )

Worldfootball.convert_reports( league: 'es.1', season: '2019/20' )
Worldfootball.convert_reports( league: 'it.1', season: '2019/20' )
Worldfootball.convert_reports( league: 'fr.1', season: '2019/20' )


puts "bye"
