require_relative 'helper'


## add 2020 leagues too e.g. island? ireland? etc.
LEAGUES_YEAR = [
  ### British Isles
  'ie.1',    # Ireland - starts Fri Feb/14 (restarts Fri Jul/31)

  ### Northern Europe
  'se.1',  ## Sweden
  'se.2',
  'fi.1',  ## Finland

  ### Asia
  'cn.1',  ## China
  'jp.1',  ## Japan
]



LEAGUES = [   # academic / regular-style season e.g 2020/21
  ### Northern Europe
  'dk.1',       # starts Fri Sep/11

  ### British Isles / Western Europe
  'sco.1',       # starts Sat Aug/1

 ### Benelux / Western Europe
 'be.1',        # starts Sat Aug/8
 'nl.1',        # starts Sat Sep/12
 'lu.1',        # starts Fri Aug/21

 #### Central Europe
 'ch.1',        # Switzerland - starts ??
 'ch.2',        #               starts ??

 'hu.1',        # Hungary        - starts ??
 'cz.1',        # Czech Republic - starts ??
 'pl.1',        # Poland         - starts Aug/28



  ### Southern Europe
  'pt.1',        # Portugal - starts ??
  'pt.2',

  'gr.1',       # starts Fri Sep/11
  'tr.1',       # starts Fri Sep/11

  ### Eastern Europe
  'ro.1',       # Romania   - starts
  'ru.1',       # Russia    - starts  Aug/8
]


REPOS = ['world']   ## all datasets in world repo for now


process( [['2020/21', LEAGUES],
          ['2020',    LEAGUES_YEAR]],
         REPOS,
         includes: ARGV
       )


puts "bye"
