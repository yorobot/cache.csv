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
        'Score',     ## note: use score (NOT FT) because score might be full time (FT), after extra time (AET), etc.
        'Team 2',
        'Tournament',   ## use / keepp "standard" league - why? why not?
        'City'        ## use venue or such - why? why not?
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


## about 3 MiBs (Megas)
path = '../../martj42/international_results/results.csv'

#######################
#{:date=>"1872-11-30",
# :home_team=>"Scotland",
# :away_team=>"England",
# :home_score=>"0",
# :away_score=>"0",
# :tournament=>"Friendly",
# :city=>"Glasgow",
# :country=>"Scotland",
# :neutral=>"FALSE"}



years = {}   # matches by year

    i = 0


    # out_root = './o'
    out_root = '../../footballcsv/cache.internationals'

    CsvHash.foreach( path, :header_converters => :symbol  ) do |row|
      i += 1

      pp row if i == 1

      print '.' if i % 100 == 0

      ## for debuggin stop after 1000
      # break  if i > 1000


      date   = row[:date]

      ## date is NA? - set to -  for not known
      date = nil    if date.empty? || date == 'NA'
      if date.nil?
        puts "!! ERROR: date missing in row:"
        pp row
        exit 1
      end

      year = Date.strptime( date, '%Y-%m-%d' ).year


      team1  = row[:home_team]
      team2  = row[:away_team]

      score1 = row[:home_score]
      score2 = row[:away_score]

      score  = "#{score1}-#{score2}"

      tournament = row[:tournament]

      city       = "#{row[:city]} › #{row[:country]}"



      values = []
      values << date
      values << team1
      values << score
      values << team2
      values << tournament
      values << city

      recs = years[ year ]  ||= []
      recs   << values
end


puts
puts

years.each do |year, recs|
    puts "#{year} - #{recs.size} records"

    ## convert to season as string e.g. 1899 to 1899-00 or 1911 to 1911-12 etc.
    century = "%2d00s" % (year/100)     # e.g. 1800s, 1900s, 2000s

    out_path = "#{out_root}/#{century}/#{year}.csv"

    ##   note:  sort matches by date before saving/writing!!!!
    ##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
    ## note: assume date is first column!!!
    recs = recs.sort { |l,r| l[0] <=> r[0] }
    ## reformat date / beautify e.g. Sat Aug 7 1993
    recs.each { |rec| rec[0] = Date.strptime( rec[0], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

    CsvMatchWriter.write( out_path, recs )
end


puts 'done'