require_relative './write_utils'


LEAGUES['au.1'] = {
  name:     'Australian A-League',
  basename: '1-aleague',
  path:     'world/pacific/australia',
  lang:     'en_AU',
}


stages = ['Regular Season', 'Finals']

write_worker_with_stages( 'au.1', '2018/19', source: 'tmp/leagues', stages: stages )

puts "bye"

