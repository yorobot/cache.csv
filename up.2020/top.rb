require_relative 'helper'



## top-level countries / leagues

LEAGUES_YEAR = [
  'br.1',    # starts Sun Aug 9      *****
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


'at.1',         # starts Fri Sep 11
'at.2',         # starts Fri Sep 11
'at.3.o',       # starts Fri Aug 21   *****
'at.cup',       # starts Fri Aug 28   *****

'fr.1',         # starts Fri Aug 21   *****
'fr.2',         # starts Sat Aug 22   *****

'es.1',         # starts Fri Sep 11
'es.2',         # starts Fri Sep 11


'it.1',         # starts Sun Sep 20
# 'it.2',

'mx.1',         # starts Fri Jul 24   *****
]



if ARGV.empty?
  REPOS    = [
              'england',
              'deutschland',
              'austria',
              'france',
              'italy',
              'espana',
              'mexico',
              'brazil',
             ]
else
  leagues = []
  repos = []
  ARGV.each do |q|   ## find all matching leagues (that is, league keys)
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



process( [['2020/21', LEAGUES],
          ['2020',    LEAGUES_YEAR]],
         REPOS,
         includes: ARGV
       )

puts "bye"

