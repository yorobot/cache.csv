require_relative '../csv'        ## pull in date_to_season helper
require_relative '../seasons'    ## pull in date_to_season helper


# OUT_DIR = './o'
OUT_DIR = '../../../footballcsv/cache.soccerverse'


=begin
{:home=>"Austria Wien",
 :away=>"FC Wien",
 :date=>"1945-09-01",
 :gh=>"10",
 :ga=>"2",
 :full_time=>"F",
 :competition=>"austria",
 :home_ident=>"Austria Wien (Austria)",
 :away_ident=>"FC Wien (Austria)",
 :home_country=>"austria",
 :away_country=>"austria",
 :home_code=>"AT",
 :away_code=>"AT",
 :home_continent=>"Europe",
 :away_continent=>"Europe",
 :continent=>"Europe",
 :level=>"national"}

{:full_time=>{"F"=>13573},
 :competition=>{"austria"=>13573},
 :country=>{"austria"=>27146},
 :code=>{"AT"=>27146},
 :continent=>{"Europe"=>13573},
 :level=>{"national"=>13573}}
=end





def date_to_season( date, league: )
  season_key = SEASONS.find_by( date: date, league: league )
  if season_key.nil?
      start_year =  if date.month >= 7
                        date.year
                    else
                        date.year-1
                    end

     season_key = '%4d/%02d' % [start_year, (start_year+1)%100]
  end
  season_key
end


MODS = {
  'br' => {
      'Bragantino' => 'CA Bragantino' },  ## ambigious/conflict with RB Bragantino - use year to separate? possible?
  'at' => {
     ## 'FC Superfund' => 'FC Pasching OR ASKOE Pasching' }  ## use - why? why not?
     },
  'de' => {
     ## 'KSC Uerdingen 05' => 'KFC Uerdingen 05'
  }
}


def convert( path, league:, start: nil )
  start = Date.strptime( start, '%Y-%m-%d' )   if start.is_a?( String )

  league_basename = league
  league_key      = league
  league  = SportDb::Import.catalog.leagues.find!( league_key )

  mods = MODS[ league_key ] || {}


  columns = {}
  seasons = {}   ## split by season

  i = 0
  CsvHash.foreach( path, :header_converters => :symbol ) do |row|
    i += 1

    pp row  if i == 1

    print '.' if i % 100 == 0

    date   = Date.strptime( row[:date], '%Y-%m-%d')

    next if start && start > date   ## skip older dates


    ## cut off country from name e.g.
    ##    Austria Wien (Austria)     => Austria Wien
    ##    As Cannes (France)         => As Cannes
    ##    Bolton Wanderers (England) => Bolton Wanderers
    ##    etc.
    if row[:home] != (row[:home_ident].sub(/[ ]+\(.+?\)$/, '').strip)
      puts "!! #{row[:home]} != #{row[:home_ident]}"
      exit 1
    end

    if row[:away] != (row[:away_ident].sub(/[ ]+\(.+?\)$/, '').strip)
      puts "!! #{row[:away]} != #{row[:away_ident]}"
      exit 1
    end

    ### mods - rename club names
    unless mods.nil? || mods.empty?
       row[:home] = mods[ row[:home] ]      if mods[ row[:home] ]
       row[:away] = mods[ row[:away] ]      if mods[ row[:away] ]
    end


    season = date_to_season( date, league: league )


    seasons[season] ||= []
    seasons[season] << [ row[:date],
                         row[:home],
                         "#{row[:gh]}-#{row[:ga]}",
                         row[:away]
                        ]

    column = columns[ :full_time] ||= Hash.new(0)
    column[ row[:full_time] ] += 1

    column = columns[ :competition] ||= Hash.new(0)
    column[ row[:competition] ] += 1

    column = columns[ :country] ||= Hash.new(0)
    column[ row[:home_country] ] += 1
    column[ row[:away_country] ] += 1

    column = columns[ :code] ||= Hash.new(0)
    column[ row[:home_code] ] += 1
    column[ row[:away_code] ] += 1

    column = columns[ :continent] ||= Hash.new(0)
    column[ row[:continent] ] += 1

    column = columns[ :level] ||= Hash.new(0)
    column[ row[:level] ] += 1
  end

  pp columns


  puts " #{seasons.size} seasons:"
  seasons.each do |key, recs|
    puts "    #{key} - #{recs.size} records"

    recs = recs.sort { |l,r| l[0] <=> r[0] }
    ## reformat date / beautify e.g. Sat Aug 7 1993
    recs.each { |rec| rec[0] = Date.strptime( rec[0], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

    headers = [
      'Date',
      'Team 1',
      'FT',
      'Team 2',
    ]

    ## note: change season_key from 2019/20 to 2019-20  (for path/directory!!!!)
    Cache::CsvMatchWriter.write( "./#{OUT_DIR}/#{key.tr('/','-')}/#{league_basename}.csv",
                                 recs,
                                 headers: headers )
  end


  ## assert all columns have only a single value
  columns.each do |column, h|
    if h.keys.size > 1
      puts "!! WARN: #{column} has more than one value:"
      pp h
    end
  end
end



at  = '../../../schochastics/football-data/data/results/austria.csv'  ## about 2 MiBs (Megas)
fr  = '../../../schochastics/football-data/data/results/france.csv'
eng = '../../../schochastics/football-data/data/results/england.csv'

es  = '../../../schochastics/football-data/data/results/spain.csv'
it  = '../../../schochastics/football-data/data/results/italy.csv'
de  = '../../../schochastics/football-data/data/results/germany.csv'

br  = '../../../schochastics/football-data/data/results/brazil.csv'     # starting in 1977
ar  = '../../../schochastics/football-data/data/results/argentina.csv'  # starting in 1910

pt  = '../../../schochastics/football-data/data/results/portugal.csv'     # starting in 1935
nl  = '../../../schochastics/football-data/data/results/netherlands.csv'  # starting in 1956



# convert( at,  league: 'at' )    # check for date_to_season (incomplete year index)
#  !! WARN: date >2011-02-12< out-of-seasons for year 2011 in league at.1:
#     2011/12 |  2011-07-16 - 2012-05-17
#  !! ERROR: CANNOT auto-fix / (auto-)append date at the end of an event; check season setup - sorry

# convert( de,  league: 'de' )


# convert( fr,  league: 'fr' )
# convert( eng, league: 'eng' )
# convert( es,  league: 'es' )
# convert( it,  league: 'it' )

convert( br,  league: 'br', start: '1990-01-01' )
# convert( ar,  league: 'ar', start: '1990-08-20' )   # start with season 1990/91

# convert( pt,  league: 'pt', start: '1989-08-19' )
# convert( nl,  league: 'nl', start: '1989-08-12' )

puts "bye"

