require_relative './write_utils'





write_worker( 'at.1', '2019/20', source: 'two/o' )
# write_worker( 'at.1', '2018/19', source: 'tmp/o' )

write_worker( 'at.1', '2016/17', source: 'two/o' )
write_worker( 'at.1', '2014/15', source: 'two/o' )



# write_worker( 'at.2', '2019/20', source: 'two/o' )


puts "bye"


