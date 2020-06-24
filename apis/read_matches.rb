require 'json'
require 'date'
require 'pp'


require_relative '../csv'        ## pull in date_to_season helper



# OUT_DIR = './o'
OUT_DIR = '../../stage/one'


LEAGUES = {
  'eng.1' => 'PL',
  'eng.2' => 'ELC',
  'br.1'  => 'BSA',
  'fr.1'  => 'FL1'
}

MODS = {
  'br.1' => { 'América FC' => 'América (MG)',   # in year 2018
            }
}


def convert( league:, year: )

  path = "./dl/competitions~~#{LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"
  puts "path=>#{path}<"

txt = File.open( path, 'r:utf-8' ) {|f| f.read }
data = JSON.parse( txt )


recs = []

teams = Hash.new( 0 )

stat = {
  all:     { duration: Hash.new( 0 ),
             stage:    Hash.new( 0 ),
             status:   Hash.new( 0 ),
             group:    Hash.new( 0 ),

             matches:  0,
             goals:    0,
           },
  regular: { duration: Hash.new( 0 ),
             stage:    Hash.new( 0 ),
             status:   Hash.new( 0 ),
             group:    Hash.new( 0 ),

             matches:  0,
             goals:    0,
  }
}

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

  stat[:all][:stage][ m['stage'] ]   += 1
  stat[:all][:group][ m['group'] ]  += 1
  stat[:all][:duration][ score['duration'] ] += 1   ## track - assert always REGULAR
  stat[:all][:status][ m['status'] ]  += 1

  stat[:all][:matches] += 1
  stat[:all][:goals]   += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
  stat[:all][:goals]   += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']


  if m['stage'] == 'REGULAR_SEASON'
    stat[:regular][:stage][ m['stage'] ]   += 1
    stat[:regular][:group][ m['group'] ]  += 1
    stat[:regular][:duration][ score['duration'] ] += 1   ## track - assert always REGULAR
    stat[:regular][:status][ m['status'] ]  += 1

    stat[:regular][:matches] += 1
    stat[:regular][:goals]   += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
    stat[:regular][:goals]   += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']


    teams[ team1 ] += 1
    teams[ team2 ] += 1


    ## e.g. "utcDate": "2020-05-09T00:00:00Z",
    date_str = m['utcDate']
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%SZ' )


    comments = ''
    ft       = ''
    ht       = ''

    case m['status']
    when 'SCHEDULED'
      ft = ''
      ht = ''
    when 'FINISHED'
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ht = "#{score['halfTime']['homeTeam']}-#{score['halfTime']['awayTeam']}"
    when 'AWARDED'
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ft << ' (*)'
      ht = ''
      comments = 'awarded'
    when 'CANCELLED'
      ft = '(*)'
      ht = ''
      comments  = 'canceled'
    when 'POSTPONED'
      ft = '(*)'
      ht = ''
      comments = 'postponed'
    else
      puts "!! ERROR: unsupported match status >#{m['status']}< - sorry:"
      pp m
      exit 1
    end


    recs << [m['matchday'],
             date.to_date.strftime( '%Y-%m-%d' ),
             team1,
             ft,
             ht,
             team2,
             comments
            ]


    print '%2s' % m['matchday']
    print ' - '
    print '%-24s' % team1
    print '  '
    print ft
    print ' '
    print "(#{ht})"    unless ht.empty?
    print '  '
    print '%-24s' % team2
    print '  '
    print comments
    print ' | '
    ## print date.to_date  ## strip time
    print date.to_date.strftime( '%a %b %-d %Y' )
    print ' -- '
    print date
    print "\n"
  else
    puts "-- skipping #{m['stage']}"
  end
end # each match


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

buf = ''
buf << "#{season_key} (#{dates}) - "
buf << "#{teams.keys.size} clubs, "
buf << "#{stat[:regular][:matches]} matches, "
buf << "#{stat[:regular][:goals]} goals"
buf << "\n"

puts buf


   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write "#{league} =============\n"
     f.write buf
   end


# recs = recs.sort { |l,r| l[1] <=> r[1] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each { |rec| rec[1] = Date.strptime( rec[1], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

headers = [
  'Matchday',
  'Date',
  'Team 1',
  'FT',
  'HT',
  'Team 2',
  'Comments'
]

## note: change season_key from 2019/20 to 2019-20  (for path/directory!!!!)
Cache::CsvMatchWriter.write( "./#{OUT_DIR}/#{season_key.tr('/','-')}/#{league.downcase}.csv",
                             recs,
                             headers: headers )



pp teams
pp stat
end   # method convert





convert( league: 'ENG.1', year: 2018 )
convert( league: 'ENG.1', year: 2019 )

convert( league: 'ENG.2', year: 2018 )
convert( league: 'ENG.2', year: 2019 )

convert( league: 'FR.1', year: 2018 )
convert( league: 'FR.1', year: 2019 )

convert( league: 'BR.1', year: 2018 )
convert( league: 'BR.1', year: 2019 )
convert( league: 'BR.1', year: 2020 )

