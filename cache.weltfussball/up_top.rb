require_relative 'helper'


## top 5

####################
## download pages

def download
  season = '2019/20'
  Worldfootball.schedule( league: 'eng.1', season: season )
  Worldfootball.schedule_reports( league: 'eng.1', season: season )

  Worldfootball.schedule( league: 'de.1', season: season )
  Worldfootball.schedule_reports( league: 'de.1', season: season )

  Worldfootball.schedule( league: 'es.1', season: season )
  Worldfootball.schedule_reports( league: 'es.1', season: season )

  Worldfootball.schedule( league: 'it.1', season: season )
  Worldfootball.schedule_reports( league: 'it.1', season: season )

  Worldfootball.schedule( league: 'fr.1', season: season )
  Worldfootball.schedule_reports( league: 'fr.1', season: season )
end



#################
## convert (cached) pages

def convert
  season = '2019/20'
  Worldfootball.convert( league: 'eng.1', season: season )
  Worldfootball.convert( league: 'de.1',  season: season )
  Worldfootball.convert( league: 'es.1',  season: season )
  Worldfootball.convert( league: 'it.1',  season: season )
  Worldfootball.convert( league: 'fr.1',  season: season )

  Worldfootball.convert_reports( league: 'eng.1', season: season )
  Worldfootball.convert_reports( league: 'de.1',  season: season )
  Worldfootball.convert_reports( league: 'es.1',  season: season )
  Worldfootball.convert_reports( league: 'it.1',  season: season )
  Worldfootball.convert_reports( league: 'fr.1',  season: season )
end


def write
  season = '2019/20'
  source = Worldfootball.config.convert.out_dir
  Writer.write( 'eng.1', season, source: source )
  Writer.write( 'de.1',  season, source: source )
  Writer.write( 'es.1',  season, source: source )
  Writer.write( 'it.1',  season, source: source )
  Writer.write( 'fr.1',  season, source: source )
end


## download

# Worldfootball.config.convert.out_dir = './o/aug25'
Worldfootball.config.convert.out_dir = './o'
convert

Writer.config.out_dir = './tmp/aug27'
write


puts "bye"
