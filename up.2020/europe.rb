require_relative 'helper'


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


REPOS = ['world']   ## all datasets in world repo for now


process( [['2020/21', LEAGUES],
          ['2020',    LEAGUES_YEAR]],
         REPOS,
         includes: ARGV
       )


puts "bye"
