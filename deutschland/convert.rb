require_relative '../boot'
require_relative '../csv'


##########
## convert "old" csv datasets from football.csv before switch-over to mirror

def convert( season )
  season_path = season.to_path( :archive )  ## e.g. 1990s/1999-00

  path = "../../../footballcsv/deutschland/#{season_path}/de.1.csv"

  matches = SportDb::CsvMatchParser.read( path )
  puts "  #{matches.size} records"

  recs = []
  matches.each do |match|
    recs << [match.round.to_s,
             match.date,
             match.team1,
             "#{match.score1}-#{match.score2}",
             "#{match.score1i}-#{match.score2i}",
             match.team2
            ]
  end

  ## sort by date
  recs = recs.sort { |l,r| l[1] <=> r[1] }
  ## reformat date / beautify e.g. Sat Aug 7 1993
  recs.each { |rec| rec[1] = Date.strptime( rec[1], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

  headers = [
    'Matchday',
    'Date',
    'Team 1',
    'FT',
    'HT',
    'Team 2'
  ]

  season_path = season.to_path   ## use default format e.g. 1999-00
  out_path = "./o/#{season_path}/de.1.csv"
  ## out_path ="../../../footballcsv/cache.leagues/#{season_path}/de.1.csv"
  Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end


## range up-to (incl.) 2013/14
(Season.new('1963/64')..Season.new('2013/14')).each do |season|
  convert( season )
end