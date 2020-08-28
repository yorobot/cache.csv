require_relative 'helper'


require_relative '../git'


## top-level countries / leagues


LEAGUES_YEAR = [
  'br.1',    # starts Sun Aug 9
]


LEAGUES = [    ## regular academic / season e.g. 2020/21
'eng.1',        # starts Sat Sep 12
'eng.2',        # starts Sat Sep 12
'eng.3',        # starts Sat Sep 12
'eng.4',        # starts Sat Sep 12
# 'eng.5',      # starts ??

'de.1',         # starts Fri Sep 18
'de.2',         # starts Fri Sep 18
'de.3',         # starts Fri Sep 18
# 'de.cup',


# ERROR - no match for club >SV St. Jakob/Rosental<

'at.1',         # starts
'at.2',         # starts
'at.cup',       # starts

'fr.1',         # starts Fri Aug 21
'fr.2',         # starts Sat Aug 22

  # 'es.1',       # starts ??
  # 'it.1',       # starts ??

'mx.1',         # starts
]


def download_pages( leagues, season,
                      includes: nil,
                      excludes: nil )
  leagues.each do |league|
    next  if excludes &&  excludes.include?( league )
    next  if includes && !includes.include?( league )

    ## todo/check: what to do: if league is both included and excluded?
    ##   include forces include? or exclude has the last word? - why? why not?
    ##  Excludes match before includes,
    ##   meaning that something that has been excluded cannot be included again

    puts "downloading #{league} #{season}..."

    Worldfootball.schedule( league: league, season: season )
  end
end


## todo - find "proper/classic" timezone ("winter time")

##  Brasilia - Distrito Federal, Brasil  (GMT-3)  -- summer time?
##  Ciudad de México, CDMX, México       (GMT-5)  -- summer time?
##  Londres, Reino Unido (GMT+1)
##   Madrid -- ?
##   Lisboa -- ?
##   Moskow -- ?
##
## todo/check - quick fix timezone offsets for leagues for now
##   - find something better - why? why not?
## note: assume time is in GMT+1
OFFSETS = {
  'eng.1' => -1,
  'eng.2' => -1,
  'eng.3' => -1,
  'eng.4' => -1,
  'eng.5' => -1,

  # 'es.1',       # starts ??

  'br.1'  => -5,
  'mx.1'  => -7,
}

def convert( leagues, season )
  leagues.each do |league|
    Worldfootball.convert( league: league,
                           season: season,
                           offset: OFFSETS[ league ] )
  end
end

def write( leagues, season,
             source:,
             includes: nil,
             excludes: nil )
  leagues.each do |league|
    next  if excludes &&  excludes.include?( league )
    next  if includes && !includes.include?( league )

    Writer.write( league, season, source: source )
  end
end


Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'
## download_pages( %w[ de.2 de.3 ])
## download_pages( %w[ eng.2 eng.3 eng.4 ])

## download_pages( %w[at.1 at.2 at.cup] )

## download_pages( LEAGUES,      '2020/21', includes: %w[ mx.1 ])
## download_pages( LEAGUES_YEAR, '2020' )

# Worldfootball.config.convert.out_dir = './o/aug25'
Worldfootball.config.convert.out_dir = './o'
convert( LEAGUES,      '2020/21' )
convert( LEAGUES_YEAR, '2020'    )

Writer.config.out_dir = './tmp'
# Writer.config.out_dir = '../../../openfootball'
write( LEAGUES,      '2020/21',
          source: Worldfootball.config.convert.out_dir )
write( LEAGUES_YEAR, '2020',
          source: Worldfootball.config.convert.out_dir )



def push
  msg = "auto-update week #{Date.today.cweek}"
  puts msg

  [
#   'england',
#   'deutschland',
   'austria',
#   'france',
#   'mexico',
#   'brazil',
  ].each do |name|
    path = "../../../openfootball/#{name}"
    git_push( path, msg )
  end
end

## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
# push

puts "bye"
