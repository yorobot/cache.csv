require_relative '../boot'
require_relative '../csv'



def write_matches( season )
  season = SportDb::Import::Season.new( season )
  decade = '%3d0s' % [season.start_year/10]

  path = "../../../footballcsv/deutschland/#{decade}/#{season.path}/de.1.csv"

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

  ## out_path = "./o/#{decade}/#{season.path}/de.1.csv"
  out_path = "./o/#{season.path}/de.1.csv"
  Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end


def season_next( season )
  season = SportDb::Import::Season.new( season )
  "%4d/%02d" % [season.start_year+1, (season.start_year+2)%100]
end


season = '1963/64'
loop do
  write_matches( season )
  season = season_next( season )

  break if season == '2014/15'
end