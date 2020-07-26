require_relative './write_utils'


LEAGUES['cz.1'] = {
  name:     'Czech First League',
  basename: '1-firstleague',
  path:     'world/europe/czech-republic',
  lang:     'en_AU',  ## uses round (and not matchday as default)
}


stages = [['Regular Season'],
          ['Playoffs - Championship',
           'Europa League Play-off',
           'Playoffs - Relegation'
          ]]

write_worker_with_stages( 'cz.1', '2018/19', source: 'tmp/leagues', stages: stages )

puts "bye"



