require 'json'
require 'pp'


=begin
BSA - Série A               , Brazil          4 seasons | 2020-05-03 - 2020-12-06 / matchday 10
ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 38
PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 31
CL  - UEFA Champions League , Europe         19 seasons | 2019-06-25 - 2020-05-30 / matchday 6
EC  - European Championship , Europe          2 seasons | 2020-06-12 - 2020-07-12 / matchday 1
FL1 - Ligue 1               , France          9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34
SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 27
DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34
PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 28
PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 31
WC  - FIFA World Cup        , World           2 seasons | 2018-06-14 - 2018-07-15 / matchday 3
=end


# path = './dl/competitions.json'
path = './dl/competitions-I-plan~TIER_ONE.json'

txt = File.open( path, 'r:utf-8' ) {|f| f.read }
data = JSON.parse( txt )

data[ 'competitions'].each do |comp|
  print '%-3s' % comp['code']
  print ' - '
  print '%-22s' % comp['name']
  print ', '
  print '%-12s' % comp['area']['name']
  print '   '
  print '%2s seasons' % comp['numberOfAvailableSeasons']
  print ' | '

  season = comp['currentSeason']
  print "#{season['startDate']} - #{season['endDate']} / matchday #{season['currentMatchday']}"
  print "\n"
end

