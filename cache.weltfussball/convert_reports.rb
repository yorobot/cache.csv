require_relative 'lib/convert'


start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


# OUT_DIR='./o'
# OUT_DIR='./o/fr'
# OUT_DIR='./o/at'
# OUT_DIR='./o/de'
# OUT_DIR='./o/eng'
# OUT_DIR='../../stage/two'


OUT_DIR='./o/aug22'
# OUT_DIR='./tmp'

# OUT_DIR='./o/test'



## get all reports for a (schedule) page
# path = './dl/at.2-2019-20.html'
# path = './dl/at.1-2014-15.html'
# path = './dl/at.1-2016-17.html'

# Worldfootball.convert_reports( league: 'at.2', season: '2019/20' )

# Worldfootball.convert_reports( league: 'eng.1', season: '2019/20' )

Worldfootball.convert_reports( league: 'at.1', season: '2014/15' )
Worldfootball.convert_reports( league: 'at.1', season: '2016/17' )

# Worldfootball.convert_reports( league: 'at.1', season: '2019/20' )



end_time = Time.now
diff_time = end_time - start_time
puts "convert_reports: done in #{diff_time} sec(s)"

puts "bye"
