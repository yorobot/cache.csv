require 'csvreader'
require 'fileutils'



## todo/fix: move CsvMatchWriter to its own file!!!!!
class CsvMatchWriter

    def self.write( path, recs )

      ## for convenience - make sure parent folders/directories exist
      FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

      headers = [
        'Date',
        'Team 1',
        'FT',
        'Team 2',
      ]

        File.open( path, 'w:utf-8' ) do |f|
          f.write headers.join(',')   ## e.g. Date,Team 1,FT,HT,Team 2
          f.write "\n"
          recs.each do |rec|
              f.write rec.join(',')
              f.write "\n"
          end
        end
    end
  end # class CsvMatchWriter




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


def date_to_season( date )
  start_year =  if date.month >= 7
                    date.year
                else
                    date.year-1
                end

  '%4d-%02d' % [start_year, (start_year+1)%100]
end


def check_datafile( path, league: )
  columns = {}

  seasons = {}   ## split by season

  i = 0
  CsvHash.foreach( path, :header_converters => :symbol  ) do |row|
    i += 1

    pp row  if i == 1

    print '.' if i % 100 == 0


    ## cut off country from name e.g.
    ##    Austria Wien (Austria)     => Austria Wien
    ##    As Cannes (France)         => As Cannes
    ##    Bolton Wanderers (England) => Bolton Wanderers
    ##    etc.
    if row[:home] != (row[:home_ident].sub(/[ ]+\(.+?\)$/, '').strip)
      puts "!! #{row[:home]} != #{row[:home_ident]}"
    end

    if row[:away] != (row[:away_ident].sub(/[ ]+\(.+?\)$/, '').strip)
      puts "!! #{row[:away]} != #{row[:away_ident]}"
    end


    date   = Date.strptime( row[:date], '%Y-%m-%d')
    season = date_to_season( date )

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

    CsvMatchWriter.write( "./o/#{key}/#{league}.csv", recs )
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

check_datafile( at,  league: 'at' )
check_datafile( fr,  league: 'fr' )
check_datafile( eng, league: 'eng' )
check_datafile( es,  league: 'es' )
check_datafile( it,  league: 'it' )
check_datafile( de,  league: 'de' )

puts "bye"

