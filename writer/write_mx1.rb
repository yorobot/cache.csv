require_relative './write_utils'



LEAGUES['mx.1'] = {
  name:     'Liga MX',
  basename: '1-ligamx',   ## note: gets "overwritten" by stages (see below)
  path:     'mexico',
  lang:     'es',
}


=begin
#  - Viertelfinale
#  - Halbfinale
#  - Finale
=end


stages = [{basename: '1-apertura',          names: ['Apertura']},
          {basename: '1-apertura_liguilla', names: ['Apertura - Liguilla']},
          {basename: '1-clausura',          names: ['Clausura']},
          {basename: '1-clausura_liguilla', names: ['Clausura - Liguilla']},
         ]

write_worker_with_stages( 'mx.1', '2018/19', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'mx.1', '2019/20', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'mx.1', '2020/21', source: 'two/tmp', stages: stages )

puts "bye"
