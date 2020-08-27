start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


require_relative 'helper'


boot_time = Time.now


Writer.config.out_dir = './o5'

Writer.write_de1( '2020/21', source: 'two/o' )
Writer.write_de2( '2020/21', source: 'two/o' )


# write_de_cup( '2018/19', source: 'tmp/two' )
# write_de_cup( '2019/20', source: 'tmp/two' )

# write_de_cup( '2012/13', source: 'tmp/two' )
# write_de_cup( '2013/14', source: 'tmp/two' )
# write_de_cup( '2014/15', source: 'tmp/two' )
# write_de_cup( '2015/16', source: 'tmp/two' )
# write_de_cup( '2016/17', source: 'tmp/two' )
# write_de_cup( '2017/18', source: 'tmp/two' )


# write_de( '2010-11' )
# write_de( '2011-12' )
# write_de( '2012-13', split: true )

# write_de( '2013-14', split: true )
# write_de2( '2013-14', source: 'two', split: true )

# write_de( '2014-15', split: true )
# write_de2( '2014-15', split: true )
# write_de3( '2014-15', split: true )

# write_de( '2015-16', split: true )
# write_de2( '2015-16', split: true )
# write_de3( '2015-16', split: true )

# write_de( '2016-17', split: true )
# write_de2( '2016-17', split: true )
# write_de3( '2016-17', split: true )

# write_de( '2017-18', split: true )
# write_de2( '2017-18', split: true )
# write_de3( '2017-18', split: true )

# write_de2( '2019/20' )
# write_de3( '2019/20' )

# write_de2( '2018/19' )
# write_de3( '2018/19' )


end_time = Time.now
print "write_de: done in #{end_time - start_time} sec(s); "
print "boot in #{boot_time - start_time} sec(s)"
print "\n"

puts "bye"
