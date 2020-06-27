require_relative '../csv'        ## pull in date_to_season helper


OUT_DIR = './o'
# OUT_DIR = '../../../footballcsv/cache.leagues'



datafiles = Dir["./dl/fbref/**/*csv"]
puts "#{datafiles.size} datafiles"

datafiles.each do |datafile|

# sample datfile format style:
#    Wk,Day,Date,Time,Home,Score,Away,Attendance,Venue,Referee,Match Report,Notes
#    1,Sat,2010-08-14,,Bolton,0–0,Fulham,,,,Match Report,
#    1,Sat,2010-08-14,,Wigan Athletic,0–4,Blackpool,,,,Match Report,

    basename = File.basename( datafile, File.extname( datafile) )
    dirname  = File.basename( File.dirname( datafile ))

    puts "#{dirname}/#{basename}: (#{datafile})"
    rows = CsvHash.read( datafile, :header_converters => :symbol )

    ## convert to records
    recs = []
    rows.each do |row|
#    Wk,Day,Date,Time,Home,Score,Away,Attendance,Venue,Referee,Match Report,Notes
#    1,Sat,2010-08-14,,Bolton,0–0,Fulham,,,,Match Report,
       next if row[:home].empty? && row[:away].empty?   # skip empty "filler" rows

       ## note: replace unicode "fancy" dash with ascii-dash
       #  check other columns too - possible in teams?
       row[:score] = row[:score].gsub( /[–]/, '-' )


       values = []

       values << row[:wk]                  # matchday
       values << Date.strptime( row[:date], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )   # e.g. Sat Aug 7 1993
       values <<  if row[:time].empty?     # time
                       '?'
                  else
                    ## e.g. 15:00 (16:00)  remove own time (only use local to venue)
                    #   note: use non-greedy (minimal) match e.g. .+?
                      row[:time].gsub( /\(.+?\)/, '' ).strip
                  end
        values << row[:home]    # team 1
        values << row[:score]   # ft
        values <<   if row[:score].empty?   # assume match still in future
                      ''
                    else
                      '?'          # ht
                    end
        values << row[:away]    # team 2


       recs << values
    end
    puts "  #{recs.size} records  (from #{rows.size} rows)"


    out_path = "#{OUT_DIR}/#{dirname}/#{basename}.csv"

    headers = [
      'Matchday',
      'Date',
      'Time',
      'Team 1',
      'FT',
      'HT',
      'Team 2'
    ]

    Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end


puts "bye"