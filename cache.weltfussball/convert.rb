require_relative 'lib/convert'



# OUT_DIR='./o'
# OUT_DIR='./o/fr'
# OUT_DIR='./o/at'
# OUT_DIR='./o/de'
# OUT_DIR='./o/eng'
# OUT_DIR='../../stage/two'

OUT_DIR='./o/aug8'
# OUT_DIR='./tmp'


=begin
DATAFILES = [['at.1',  %w[2010/11 2011/12 2012/13 2013/14 2014/15
                          2015/16 2016/17 2017/18]],
             ['at.2',  %w[2010/11 2011/12
                          2018/19 2019/20]],
             ['de.2',  %w[2013/14]],
             ['eng.3', %w[2018/19 2019/20]],
             ['eng.4', %w[2017/18 2018/19 2019/20]],

             ['ch.1', %w[2019/20]],
             ['ch.2', %w[2019/20]],

             ['fr.2', %w[2019/20]],

             ['it.2', %w[2019/20]],

             ['ru.1', %w[2019/20]],
             ['ru.2', %w[2019/20]],

             ['tr.1', %w[2019/20]],
             ['tr.2', %w[2019/20]],
            ]
=end

=begin
DATAFILES = [
  ['it.2', %w[2013/14 2014/15 2015/16 2016/17 2017/18 2018/19]],
  ['fr.2', %w[2015/16 2016/17 2017/18 2018/19]],
  ['es.2', %w[2012/13 2013/14 2014/15 2015/16 2016/17 2017/18 2018/19 2019/20]],
]

pp DATAFILES

DATAFILES.each do |datafile|
  basename = datafile[0]
  datafile[1].each do |season|
    convert( league: basename, season: season )
  end
end
=end


# convert( league: 'at.cup', season: '2019/20' )
# convert( league: 'at.cup', season: '2018/19' )

# convert( league: 'at.cup', season: '2011/12' )
# convert( league: 'at.cup', season: '2012/13' )
# convert( league: 'at.cup', season: '2013/14' )
# convert( league: 'at.cup', season: '2014/15' )
# convert( league: 'at.cup', season: '2015/16' )
# convert( league: 'at.cup', season: '2016/17' )
# convert( league: 'at.cup', season: '2017/18' )

# convert( league: 'at.2', season: '2014/15' )
# convert( league: 'at.2', season: '2015/16' )
# convert( league: 'at.2', season: '2016/17' )
# convert( league: 'at.2', season: '2017/18' )


# convert( league: 'de.cup', season: '2019/20' )
# convert( league: 'de.cup', season: '2018/19' )

# convert( league: 'de.cup', season: '2012/13' )
# convert( league: 'de.cup', season: '2013/14' )
# convert( league: 'de.cup', season: '2014/15' )
# convert( league: 'de.cup', season: '2015/16' )
# convert( league: 'de.cup', season: '2016/17' )
# convert( league: 'de.cup', season: '2017/18' )

# convert( league: 'eng.5', season: '2018/19' )
# convert( league: 'eng.5', season: '2019/20' )

# convert( league: 'eng.cup', season: '2018/19' )
# convert( league: 'eng.cup', season: '2019/20' )

# convert( league: 'eng.cup.l', season: '2019/20' )


# convert( league: 'eng.4', season: '2019/20' )
# convert( league: 'eng.4', season: '2018/19' )
# convert( league: 'eng.4', season: '2017/18' )


# convert( league: 'fr.1', season: '2020/21' )
# convert( league: 'fr.2', season: '2020/21' )


convert( league: 'se.1', season: '2020' )
convert( league: 'se.1', season: '2019' )

convert( league: 'se.2', season: '2020' )
convert( league: 'se.2', season: '2019' )


# convert( league: 'fi.1', season: '2020' )
# convert( league: 'fi.1', season: '2019' )

# convert( league: 'no.1', season: '2020' )
# convert( league: 'no.1', season: '2019' )

# convert( league: 'is.1', season: '2020' )
# convert( league: 'is.1', season: '2019' )

# convert( league: 'ie.1', season: '2020' )
# convert( league: 'ie.1', season: '2019' )

# convert( league: 'sco.1', season: '2020/21' )
# convert( league: 'sco.1', season: '2019/20' )
# convert( league: 'sco.1', season: '2018/19' )


# convert( league: 'be.1', season: '2020/21' )
# convert( league: 'be.1', season: '2019/20' )
# convert( league: 'be.1', season: '2018/19' )


## note: adjust date/time by -7 offset
# convert( league: 'mx.1', season: '2020/21', offset: -7 )
# convert( league: 'mx.1', season: '2019/20', offset: -7 )
# convert( league: 'mx.1', season: '2018/19', offset: -7 )

