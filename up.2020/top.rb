require_relative 'helper'



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


'at.1',         # starts
'at.2',         # starts
'at.3.o',       # starts
'at.cup',       # starts

'fr.1',         # starts Fri Aug 21
'fr.2',         # starts Sat Aug 22

  # 'es.1',       # starts ??
  # 'it.1',       # starts ??

'mx.1',         # starts
]



if ARGV.empty?
  INCLUDES = nil
  REPOS    = [
              'england',
              'deutschland',
              'austria',
              'france',
              'mexico',
              'brazil',
             ]
else
  INCLUDES = ARGV

  leagues = []
  repos = []
  INCLUDES.each do |q|   ## find all matching leagues (that is, league keys)
    more_leagues = (LEAGUES + LEAGUES_YEAR).find_all {|league| league.start_with?(q) }
    leagues += more_leagues  if more_leagues
  end

  leagues.each do |league|
    league_info = Writer::LEAGUES[ league ]
    pp league_info
    path = league_info[:path]

    ## use only first part e.g. world/europe/belgium => world
    repos << path.split( %r{[/\\]})[0]
  end

  repos
  pp repos
  REPOS = repos.uniq
  pp REPOS
end




Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'
## download_pages( %w[ de.2 de.3 ])
## download_pages( %w[ eng.2 eng.3 eng.4 ])

## download_pages( %w[at.1 at.2 at.cup] )

if OPTS[:download]
  download_pages( LEAGUES,      '2020/21', includes: INCLUDES )
  download_pages( LEAGUES_YEAR, '2020',    includes: INCLUDES )
end


# Worldfootball.config.convert.out_dir = './o/aug29'
Worldfootball.config.convert.out_dir = './o'
convert( LEAGUES,      '2020/21', includes: INCLUDES )
convert( LEAGUES_YEAR, '2020',    includes: INCLUDES )


if OPTS[:push]
  Writer.config.out_dir = '../../../openfootball'
else
  Writer.config.out_dir = './tmp'
end
write( LEAGUES,      '2020/21', includes: INCLUDES )
write( LEAGUES_YEAR, '2020',    includes: INCLUDES    )



## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
push( REPOS )    if OPTS[:push]



puts "INCLUDES:"
pp INCLUDES
puts "REPOS:"
pp REPOS

puts "bye"
