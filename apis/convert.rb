require_relative 'read'



require_relative '../csv'



OUT_DIR = './o'
# OUT_DIR = '../../stage/one'




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

stat  =  Stat.new

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
  stat.update( m )

  team1 = m['homeTeam']['name']
  team2 = m['awayTeam']['name']

  score = m['score']



  if m['stage'] == 'REGULAR_SEASON'
    teams[ team1 ] += 1
    teams[ team2 ] += 1

    ### mods - rename club names
    unless mods.nil? || mods.empty?
      team1 = mods[ team1 ]      if mods[ team1 ]
      team2 = mods[ team2 ]      if mods[ team2 ]
    end


    ## e.g. "utcDate": "2020-05-09T00:00:00Z",
    date_str = m['utcDate']
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%SZ' )


    comments = ''
    ft       = ''
    ht       = ''

    case m['status']
    when 'SCHEDULED', 'IN_PLAY'
      ft = ''
      ht = ''
    when 'FINISHED'
      ## todo/fix: assert duration == "REGULAR"
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ht = "#{score['halfTime']['homeTeam']}-#{score['halfTime']['awayTeam']}"
    when 'AWARDED'
      ## todo/fix: assert duration == "REGULAR"
      ft = "#{score['fullTime']['homeTeam']}-#{score['fullTime']['awayTeam']}"
      ft << ' (*)'
      ht = ''
      comments = 'awarded'
    when 'CANCELLED'
      ft = '(*)'
      ht = ''
      comments  = 'canceled'   ## us eng ? -> canceled, british eng. cancelled ?
    when 'POSTPONED'
      ft = '(*)'
      ht = ''
      comments = 'postponed'
    else
      puts "!! ERROR: unsupported match status >#{m['status']}< - sorry:"
      pp m
      exit 1
    end


    ## todo/fix: assert matchday is a number e.g. 1,2,3, etc.!!!
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
buf << "#{stat[:regular_season][:matches]} matches, "
buf << "#{stat[:regular_season][:goals]} goals"
buf << "\n"

puts buf



   ## note: warn if stage is greater one and not regular season!!
   File.open( './errors.txt' , 'a:utf-8' ) do |f|
     if stat[:all][:stage].keys != ['REGULAR_SEASON']
      f.write "!! WARN - league: #{league}, year: #{year} includes non-regular stage(s):\n"
      f.write "   #{stat[:all][:stage].keys.inspect}\n"
     end
   end


   File.open( './logs.txt', 'a:utf-8' ) do |f|
     f.write "\n================================\n"
     f.write "====  #{league}  =============\n"
     f.write buf
     f.write "  match status: #{stat[:regular_season][:status].inspect}\n"
     f.write "  match duration: #{stat[:regular_season][:duration].inspect}\n"

     f.write "#{teams.keys.size} teams:\n"
     teams.each do |name, count|
        rec = teams_by_name[ name ]
        f.write "  #{count}x  #{name}"
        if rec
          f.write " | #{rec['shortName']} "   if name != rec['shortName']
          f.write " › #{rec['area']['name']}"
          f.write "  - #{rec['address']}"
        else
          puts "!! ERROR - no team record found in teams.json for >#{name}<"
          exit 1
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
    puts "!! ERROR  - no team record found in teams.json for #{name}"
    exit 1
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

DATASETS = [['NL.1',  %w[2018 2019]],
            ['PT.1',  %w[2018 2019]],
            ['ENG.1', %w[2018 2019]],
            ['ENG.2', %w[2018 2019]],
            #['BR.1',  %w[2020 2019 2018]],
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
