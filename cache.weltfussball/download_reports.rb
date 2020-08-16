require_relative 'lib/convert'


## get all reports for a (schedule) page
# path = './dl/at.2-2019-20.html'
# path = './dl/at.1-2014-15.html'
# path = './dl/at.1-2016-17.html'
# path = './dl/eng.1-2019-20.html'


# slug = 'aut-bundesliga-2019-2020'
# slug = 'aut-bundesliga-2019-2020-meistergruppe'
# slug = 'aut-bundesliga-2019-2020-qualifikationsgruppe'
# slug = 'aut-bundesliga-2019-2020-playoff'

# Worldfootball::Metal.schedule_reports( slug )

Worldfootball.schedule_reports( league: 'at.1', season: '2019/20' )
# Worldfootball.schedule_reports( league: 'eng.1', season: '2019/20' )

puts "bye"

