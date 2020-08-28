require_relative './write_utils'



write_worker_with_stages( 'mx.1', '2018/19', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'mx.1', '2019/20', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'mx.1', '2020/21', source: 'two/tmp', stages: stages )

puts "bye"
