require_relative 'helper'


require_relative '../git'



## add 2020 leagues too e.g. island? ireland? etc.
LEAGUES_YEAR = [
  'ie.1',    # starts Fri Feb/14 (restarts Fri Jul/31)
]



LEAGUES = [   # academic / regular-style season e.g 2020/21
 # 'pt.1',       # starts ??

 'be.1',        # starts Sat Aug/8
 'nl.1',        # starts Sat Sep/12
 'lu.1',        # starts Fri Aug/21

 'sco.1',       # starts Sat Aug/1
]


def download_pages( leagues, season, filter=nil )
  leagues.each do |league|
    next  if filter && !filter.include?( league )

    puts "downloading #{league} #{season}..."

    Worldfootball.schedule( league: league, season: season )
  end
end

def convert( leagues, season )
  leagues.each do |league|
    Worldfootball.convert( league: league, season: season )
  end
end

def write( leagues, season )
  leagues.each do |league|
    Writer.write( league, season,
                  source: Worldfootball.config.convert.out_dir )
  end
end


Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'

# download_pages( LEAGUES, '2020/21' )
# download_pages( LEAGUES,      '2020/21', %w[ sco.1 ] )
# download_pages( LEAGUES_YEAR, '2020' )

## download_pages( %w[ de.2 de.3 ])
## download_pages( %w[ eng.2 eng.3 eng.4 ])



# Worldfootball.config.convert.out_dir = './o/aug25'
Worldfootball.config.convert.out_dir = './o'
convert( LEAGUES,      '2020/21' )
convert( LEAGUES_YEAR, '2020' )

Writer.config.out_dir = './tmp'
# Writer.config.out_dir = '../../../openfootball'
write( LEAGUES,      '2020/21' )
write( LEAGUES_YEAR, '2020' )



def push
  msg = "auto-update week #{Date.today.cweek}"
  puts msg

  ['world',
  ].each do |name|
    path = "../../../openfootball/#{name}"
    git_push( path, msg )
  end
end

## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
# push

puts "bye"
