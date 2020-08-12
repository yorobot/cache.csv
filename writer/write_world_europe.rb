start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


require_relative './write_utils'


boot_time = Time.now



# is.1 - 2 seasons (2019 2020)
write_is( '2019', source: 'two/o' )
write_is( '2020', source: 'two/o' )

# sco.1 - 3 seasons (2018-19 2019-20 2020-21)
write_sco( '2018/19', source: 'two/tmp' )
write_sco( '2019/20', source: 'two/tmp' )
write_sco( '2020/21', source: 'two/tmp' )

# ie.1 - 2 seasons (2019 2020)
write_ie( '2019', source: 'two/o' )
write_ie( '2020', source: 'two/o' )


# fi.1 - 2 seasons (2019 2020)
write_fi( '2019', source: 'two/o' )
write_fi( '2020', source: 'two/o' )

# se.1 - 2 seasons (2019 2020):
# se.2 - 2 seasons (2019 2020):
write_se(  '2019', source: 'two/o' )
write_se(  '2020', source: 'two/o' )

write_se2( '2019', source: 'two/o' )
write_se2( '2020', source: 'two/o' )

# no.1 - 2 seasons (2019 2020)
write_no(  '2019', source: 'two/o' )
write_no(  '2020', source: 'two/o' )


# dk.1 - 3 seasons (2018-19 2019-20 2020-21)
write_dk(  '2018/19', source: 'two/o' )
write_dk(  '2019/20', source: 'two/o' )
write_dk(  '2020/21', source: 'two/o' )


# sk.1 - 3 seasons (2018-19 2019-20 2020-21)
write_sk(  '2018/19', source: 'two/o' )
write_sk(  '2019/20', source: 'two/o' )
write_sk(  '2020/21', source: 'two/o' )

# pl.1 - 3 seasons (2018-19 2019-20 2020-21)
write_pl(  '2018/19', source: 'two/o' )
write_pl(  '2019/20', source: 'two/o' )
write_pl(  '2020/21', source: 'two/o' )

# hr.1 - 3 seasons (2018-19 2019-20 2020-21)
write_hr(  '2018/19', source: 'two/o' )
write_hr(  '2019/20', source: 'two/o' )
write_hr(  '2020/21', source: 'two/o' )



# be.1 - 3 seasons (2018-19 2019-20 2020-21)
write_be( '2018/19', source: 'two/o' )
write_be( '2019/20', source: 'two/o' )
write_be( '2020/21', source: 'two/o' )

# nl.1
write_nl( '2020/21', source: 'two/o' )

# lu.1 - 3 seasons (2018-19 2019-20 2020-21)
write_lu( '2018/19', source: 'two/o' )
write_lu( '2019/20', source: 'two/o' )
write_lu( '2020/21', source: 'two/o' )


# ua.1 - 2 seasons (2018-19 2019-20)
write_ua( '2018/19', source: 'two/o' )
write_ua( '2019/20', source: 'two/o' )





end_time = Time.now
print "write_world_europe: done in #{end_time - start_time} sec(s); "
print "boot in #{boot_time - start_time} sec(s)"
print "\n"

puts "bye"
