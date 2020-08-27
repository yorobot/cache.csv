require_relative 'helper'


## top 5 countries / leagues

LEAGUES = [
'eng.1',        # starts Sat Sep 12
'eng.2',        # starts Sat Sep 12
'eng.3',        # starts Sat Sep 12
'eng.4',        # starts Sat Sep 12
# 'eng.5',      # starts ??

'de.1',         # starts Fri Sep 18
'de.2',         # starts Fri Sep 18
'de.3',         # starts Fri Sep 18

'fr.1',         # starts Fri Aug 21
'fr.2',         # starts Sat Aug 22

  # 'es.1',       # starts ??
  # 'it.1',       # starts ??
 ]


def download_pages( filter=nil )
  LEAGUES.each do |league|
    season = '2020/21'
    next  if filter && !filter.include?( league )

    puts "downloading #{league} #{season}..."

    Worldfootball.schedule( league: league, season: season )
  end
end

def convert
  LEAGUES.each do |league|
    season = '2020/21'
    Worldfootball.convert( league: league, season: season )
  end
end

def write
  LEAGUES.each do |league|
    season = '2020/21'
    Writer.write( league, season,
                  source: Worldfootball.config.convert.out_dir )
  end
end


Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'
## download_pages( %w[ de.2 de.3 ])
## download_pages( %w[ eng.2 eng.3 eng.4 ])
## __END__


# Worldfootball.config.convert.out_dir = './o/aug25'
Worldfootball.config.convert.out_dir = './o'
convert

Writer.config.out_dir = './tmp'
write


puts "bye"
