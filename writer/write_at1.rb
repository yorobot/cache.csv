require_relative './write_utils'



stages = [['Grunddurchgang'],
          ['Finaldurchgang - Meister',
           'Finaldurchgang - Qualifikation',
           'Europa League Play-off']]

write_worker_with_stages( 'at.1', '2018/19', source: 'tmp/leagues', stages: stages )
write_worker_with_stages( 'at.1', '2019/20', source: 'tmp/leagues', stages: stages )

puts "bye"


