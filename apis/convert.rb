require 'json'
require 'date'
require 'pp'


require_relative '../csv'        ## pull in date_to_season helper



# OUT_DIR = './o'
OUT_DIR = '../../stage/one'


LEAGUES = {
  'eng.1' => 'PL',     # incl. team(s) from wales
  'eng.2' => 'ELC',
  'es.1'  => 'PD',
  'pt.1'  => 'PPL',
  'de.1'  => 'BL1',
  'nl.1'  => 'DED',
  'fr.1'  => 'FL1',    # incl. team(s) monaco
  'it.1'  => 'SA',
  'br.1'  => 'BSA',

  'champs' => 'CL',
}

# e.g.
# Cardiff City FC | Cardiff  › Wales  - Cardiff City Stadium, Leckwith Road Cardiff CF11 8AZ
# AS Monaco FC | Monaco  › Monaco     - Avenue des Castellans Monaco 98000



MODS = {
  'br.1' => {
         'América FC' => 'América MG',   # in year 2018
            },
  'pt.1'  => {
         'Vitória SC' => 'Vitória Guimarães',  ## avoid easy confusion with Vitória SC <=> Vitória FC
         'Vitória FC' => 'Vitória Setúbal',
           },
}


def read_json( path )
  puts "path=>#{path}<"
  txt = File.open( path, 'r:utf-8' ) {|f| f.read }
  data = JSON.parse( txt )
  data
end


def convert( league:, year: )

  path         = "./dl/competitions~~#{LEAGUES[league.downcase]}~~matches-I-season~#{year}.json"
  path_teams   = "./dl/competitions~~#{LEAGUES[league.downcase]}~~teams-I-season~#{year}.json"

  data         = read_json( path )
  data_teams   = read_json( path_teams )


  ## build a (reverse) team lookup by name
  puts "#{data_teams['teams'].size} teams"

  teams_by_name = data_teams['teams'].reduce( {} ) do |h,rec|
     h[ rec['name'] ] = rec
     h
  end

  pp teams_by_name.keys



mods = MODS[ league.downcase ] || {}


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

  ### mods - rename club names
  unless mods.nil? || mods.empty?
    team1 = mods[ team1 ]      if mods[ team1 ]
    team2 = mods[ team2 ]      if mods[ team2 ]
  end



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
    when 'IN_PLAY'
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
     f.write "\n================================\n"
     f.write "====  #{league}  =============\n"
     f.write buf
     f.write "  match status: #{stat[:regular][:status].inspect}\n"

     ### report warning if matches different from
     ##   all and regular and print stage or something!!!

     f.write "#{teams.keys.size} teams:\n"
     teams.each do |name, count|
        rec = teams_by_name[ name ]
        f.write "  #{count}x  #{name}"
        if rec
          f.write " | #{rec['shortName']} "   if name != rec['shortName']
          f.write " › #{rec['area']['name']}"
          f.write "  - #{rec['address']}"
        else
          f.write " -- !! WARN - no team record found in teams.json"
        end
        f.write "\n"
     end
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


teams.each do |name, count|
  rec = teams_by_name[ name ]
  print "  #{count}x  "
  print name
  if rec
    print " | #{rec['shortName']} "   if name != rec['shortName']
    print " › #{rec['area']['name']}"
    print "  - #{rec['address']}"
  else
    print " -- !! WARN - no team record found in teams.json"
  end
  print "\n"
end

pp stat
end   # method convert




=begin
DATASETS = [['BR.1',  %w[2018 2019 2020]],
            ['DE.1',  %w[2018 2019]],
            ['NL.1',  %w[2018 2019]],
            ['ES.1',  %w[2018 2019]],
            ['PT.1',  %w[2018 2019]],
            ['ENG.1', %w[2018 2019]],
            ['ENG.2', %w[2018 2019]],
            ['FR.1',  %w[2018 2019]],
            ['IT.1',  %w[2018 2019]],
           ]
=end

DATASETS = [#['NL.1',  %w[2018 2019]],
            #['PT.1',  %w[2018 2019]],
            ['BR.1',  %w[2020 2019 2018]],
           ]

pp DATASETS

DATASETS.each do |dataset|
  basename = dataset[0]
  dataset[1].each do |year|
    convert( league: basename, year: year )
  end
end


=begin
convert( league: 'ENG.1', year: 2018 )
convert( league: 'ENG.1', year: 2019 )

convert( league: 'ENG.2', year: 2018 )
convert( league: 'ENG.2', year: 2019 )

convert( league: 'ES.1', year: 2018 )
convert( league: 'ES.1', year: 2019 )

convert( league: 'PT.1', year: 2018 )
convert( league: 'PT.1', year: 2019 )

convert( league: , year: 2018 )
convert( league: 'DE.1', year: 2019 )

convert( league: 'NL.1', year: 2018 )
convert( league: 'NL.1', year: 2019 )

convert( league: 'FR.1', year: 2018 )
convert( league: 'FR.1', year: 2019 )

convert( league: 'IT.1', year: 2018 )
convert( league: 'IT.1', year: 2019 )

convert( league: 'BR.1', year: 2018 )
convert( league: 'BR.1', year: 2019 )
convert( league: 'BR.1', year: 2020 )
=end

# convert( league: 'FR.1',  year: 2019 )
# convert( league: 'ENG.1', year: 2018 )

# convert( league: 'ENG.1', year: 2019 )
# convert( league: 'ENG.2', year: 2019 )
