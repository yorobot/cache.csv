require_relative './write_utils'



LEAGUES['sco.1'] = {
  name:     'Scottish Premiership',
  basename: '1-premiership',
  path:     'world/europe/scotland',
  lang:     'en_AU',  ## uses round (and not matchday as default)
}

stages = [['Regular Season'],
          ['Playoffs - Championship',
           'Playoffs - Relegation' ]]

write_worker_with_stages( 'sco.1', '2018/19', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'sco.1', '2019/20', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'sco.1', '2020/21', source: 'two/tmp', stages: stages )

puts "bye"
