start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


require_relative './write_utils'


boot_time = Time.now



# is.1 - 2 seasons (2019 2020)
write_is1( '2019', source: 'two/o' )
write_is1( '2020', source: 'two/o' )

# sco.1 - 3 seasons (2018-19 2019-20 2020-21)
write_sco1( '2018/19', source: 'two/tmp' )
write_sco1( '2019/20', source: 'two/tmp' )
write_sco1( '2020/21', source: 'two/tmp' )

# ie.1 - 2 seasons (2019 2020)
write_ie1( '2019', source: 'two/o' )
write_ie1( '2020', source: 'two/o' )


# fi.1 - 2 seasons (2019 2020)
write_fi1( '2019', source: 'two/o' )
write_fi1( '2020', source: 'two/o' )

# se.1 - 2 seasons (2019 2020):
# se.2 - 2 seasons (2019 2020):
write_se1(  '2019', source: 'two/o' )
write_se1(  '2020', source: 'two/o' )

write_se2( '2019', source: 'two/o' )
write_se2( '2020', source: 'two/o' )

# no.1 - 2 seasons (2019 2020)
write_no1(  '2019', source: 'two/o' )
write_no1(  '2020', source: 'two/o' )


# dk.1 - 3 seasons (2018-19 2019-20 2020-21)
write_dk1(  '2018/19', source: 'two/o' )
write_dk1(  '2019/20', source: 'two/o' )
write_dk1(  '2020/21', source: 'two/o' )


# sk.1 - 3 seasons (2018-19 2019-20 2020-21)
write_sk1(  '2018/19', source: 'two/o' )
write_sk1(  '2019/20', source: 'two/o' )
write_sk1(  '2020/21', source: 'two/o' )

# pl.1 - 3 seasons (2018-19 2019-20 2020-21)
write_pl1(  '2018/19', source: 'two/o' )
write_pl1(  '2019/20', source: 'two/o' )
write_pl1(  '2020/21', source: 'two/o' )

# hr.1 - 3 seasons (2018-19 2019-20 2020-21)
write_hr1(  '2018/19', source: 'two/o' )
write_hr1(  '2019/20', source: 'two/o' )
write_hr1(  '2020/21', source: 'two/o' )



# be.1 - 3 seasons (2018-19 2019-20 2020-21)
write_be1( '2018/19', source: 'two/o' )
write_be1( '2019/20', source: 'two/o' )
write_be1( '2020/21', source: 'two/o' )

# nl.1
write_nl1( '2020/21', source: 'two/o' )

# lu.1 - 3 seasons (2018-19 2019-20 2020-21)
write_lu1( '2018/19', source: 'two/o' )
write_lu1( '2019/20', source: 'two/o' )
write_lu1( '2020/21', source: 'two/o' )


# ua.1 - 2 seasons (2018-19 2019-20)
write_ua1( '2018/19', source: 'two/o' )
write_ua1( '2019/20', source: 'two/o' )





end_time = Time.now
print "write_world_europe: done in #{end_time - start_time} sec(s); "
print "boot in #{boot_time - start_time} sec(s)"
print "\n"

puts "bye"
