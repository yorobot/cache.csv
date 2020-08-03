require_relative './write_utils'


LEAGUES['be.1'] = {
  name:     'Belgian First Division A',
  basename: '1-firstdivisiona',
  path:     'world/europe/belgium',
  lang:     'en_AU',  ## uses round (and not matchday as default)
}


stages = [['Regular Season'],
          ['Playoffs - Championship',
           'Playoffs - Europa League',
           'Playoffs - Europa League - Finals' ]]

write_worker_with_stages( 'be.1', '2018/19', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'be.1', '2019/20', source: 'two/tmp', stages: stages )
write_worker_with_stages( 'be.1', '2020/21', source: 'two/tmp', stages: stages )

puts "bye"
