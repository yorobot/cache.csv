require_relative './write_utils'


LEAGUES['be.1'] = {
  name:     'Belgian First Division A',
  basename: '1-firstdivisiona',
  path:     'world/europe/belgium',
  lang:     'en_AU',  ## uses round (and not matchday as default)
}


stages = [['Regular Season'],
          ['Championship play-off']]

write_worker_with_stages( 'be.1', '2018/19', source: 'tmp/leagues', stages: stages )

puts "bye"
