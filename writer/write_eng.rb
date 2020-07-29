require_relative './write_utils'


write_eng1( '1888/89', source: 'soccerdata', rounds: false, extra: 'archive/1880s' )
write_eng1( '1889/90', source: 'soccerdata', rounds: false, extra: 'archive/1880s' )
write_eng1( '1890/91', source: 'soccerdata', rounds: false, extra: 'archive/1890s' )
write_eng1( '1891/92', source: 'soccerdata', rounds: false, extra: 'archive/1890s' )

write_eng1( '1892/93', source: 'soccerdata', rounds: false, extra: 'archive/1890s' )
write_eng2( '1892/93', source: 'soccerdata', rounds: false, extra: 'archive/1890s' )



# write_eng( '1992/93', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1993/94', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1994/95', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1995/96', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1996/97', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1997/98', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '2000/01', source: 'leagues', extra: 'archive/2000s')

# write_eng( '2001/02', source: 'leagues', extra: 'archive/2000s')
# write_eng( '2002/03', source: 'leagues', extra: 'archive/2000s')
# write_eng( '2003/04', source: 'leagues', extra: 'archive/2000s')


# write_eng( '2010/11', source: 'leagues' )
# write_eng( '2011/12', source: 'leagues' )
# write_eng( '2012/13', source: 'leagues' )
# write_eng( '2013/14', source: 'leagues' )
# write_eng( '2014/15', source: 'leagues' )
# write_eng( '2015/16', source: 'leagues' )
# write_eng( '2016/17', source: 'leagues' )
# write_eng( '2017/18', source: 'leagues' )

# write_eng( '2018/19' )


# write_eng2( '2018/19' )

# write_eng( '2019/20' )
# write_eng2( '2019/20' )

# write_eng3( '2019/20' )
# write_eng4( '2019/20' )

# write_eng3( '2018/19' )
# write_eng4( '2018/19' )

# write_eng5( '2018/19', source: 'tmp/two' )
# write_eng5( '2019/20', source: 'tmp/two' )

# write_eng_cup( '2018/19', source: 'tmp/two' )  ## todo/check: use _fa_cup or such - why? why not?
# write_eng_cup( '2019/20', source: 'tmp/two' )


puts "bye"
