require 'json'
require 'date'
require 'pp'


path = './dl/competitions~~FL1~~matches-I-season~2019.json'
# path = './dl/competitions~~PL~~matches-I-season~2019.json'
# path = './dl/competitions~~ELC~~matches-I-season~2018.json'
# path = './dl/competitions~~BSA~~matches-I-season~2020.json'


txt = File.open( path, 'r:utf-8' ) {|f| f.read }
data = JSON.parse( txt )


teams = Hash.new( 0 )

cols = {}
cols[:duration] = Hash.new( 0 )
cols[:stage]    = Hash.new( 0 )
cols[:status]   = Hash.new( 0 )
cols[:group]    = Hash.new( 0 )

goals = 0

matches = data[ 'matches']


## note: get season from first match
##   assert - all other matches include the same season
## e.g.
# "season": {
#  "id": 154,
#  "startDate": "2018-08-03",
#  "endDate": "2019-05-05",
#  "currentMatchday": 46
# }

season = matches[0]['season']
start_date = Date.strptime( season['startDate'], '%Y-%m-%d' )
end_date   = Date.strptime( season['endDate'],   '%Y-%m-%d' )




matches.each do |m|
  team1 = m['homeTeam']['name']
  team2 = m['awayTeam']['name']

  score = m['score']

  goals += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
  goals += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']


  ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
  ht = "#{score['halfTime']['homeTeam']}-#{score['halfTime']['awayTeam']}"

  cols[:duration][ score['duration'] ] += 1   ## track - assert always REGULAR
  cols[:stage][ m['stage'] ]   += 1
  cols[:status][ m['status'] ]  += 1
  cols[:group][ m['group'] ]  += 1

  teams[ team1 ] += 1
  teams[ team2 ] += 1

  ## e.g. "utcDate": "2020-05-09T00:00:00Z",
  date_str = m['utcDate']
  date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%SZ' )

  print '%2s' % m['matchday']
  print ' - '
  print '%-24s' % team1
  print "  #{ft} (#{ht})  "
  print '%-24s' % team2
  print '   '
  print ' | '
  ## print date.to_date  ## strip time
  print date.to_date.strftime( '%a %b %-d %Y' )
  print ' -- '
  print date
  print "\n"
end

season_key = if start_date.year == end_date.year
               "%4d" % start_date.year
             elsif start_date.year+1 == end_date.year
               "%4d/%02d" % [start_date.year,end_date.year%100]
             else
               puts "!! ERROR: expected season e.g. 2020 or 2019/2020; got:"
               pp start_date
               pp end_date
               exit 1
             end

dates = "#{start_date.strftime('%b %-d')} - #{end_date.strftime('%b %-d')}"
puts "#{season_key} (#{dates}) - #{teams.keys.size} clubs, #{matches.size} matches, #{goals} goals"

pp teams
pp cols
