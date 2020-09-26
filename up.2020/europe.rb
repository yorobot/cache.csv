require_relative 'helper'


## add 2020 leagues too e.g. island? ireland? etc.
LEAGUES_YEAR = [
  ### British Isles
  'ie.1',    # Ireland - starts Fri Feb/14 (restarts Fri Jul/31)

  ### Northern Europe
  'se.1',  ## Sweden
  'se.2',


 ### todo/fix: move to Asia :-) or something!!!!!
  'cn.1',  ## China
  'jp.1',  ## Japan
]



LEAGUES = [   # academic / regular-style season e.g 2020/21
 ### Southern Europe
 'pt.1',        # Portugal - starts ??
 'pt.2',

 ### Benelux
 'be.1',        # starts Sat Aug/8
 'nl.1',        # starts Sat Sep/12
 'lu.1',        # starts Fri Aug/21

 #### Central Europe
 'ch.1',        # Switzerland - starts ??
 'ch.2',        #               starts ??

 'hu.1',        # Hungary        - starts ??
 'cz.1',        # Czech Republic - starts ??

  ### British Isles
 'sco.1',       # starts Sat Aug/1

 ### todo/fix: move to Asia :-) or something!!!!!

]


REPOS = ['world']   ## all datasets in world repo for now


process( [['2020/21', LEAGUES],
          ['2020',    LEAGUES_YEAR]],
         REPOS,
         includes: ARGV
       )


puts "bye"
