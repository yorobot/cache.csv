require 'csvreader'
require 'fileutils'


###
## note: report upstream - open issue ticket on github
##   on latest england.csv dataset the division is a NUMERIC field
##    and all 3a, 3b divisions are set to NA !!!!
##
##  workaround (for now) - use an older version of the dataset


## todo/fix: move CsvMatchWriter to its own file!!!!!
class CsvMatchWriter

    def self.write( path, recs )

      ## for convenience - make sure parent folders/directories exist
      FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

      headers = [
        'Date',
        'Team 1',
        'FT',
        'Team 2'
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





## about 15 MiBs (Megas)
path = '../../jalapic/engsoccerdata/data-raw/england.csv'


###
## Date,Season,home,visitor,FT,hgoal,vgoal,division,tier,totgoal,goaldif,result
##  NA,1888,"Aston Villa","Accrington F.C.","4-3",4,3,"1",1,7,1,"H"
##  NA,1888,"Blackburn Rovers","Accrington F.C.","5-5",5,5,"1",1,10,0,"D"

years = {}   # by leagues by year / season

    i = 0


    # out_root = './o'
    out_root = '../../footballcsv/cache.soccerdata'

    CsvHash.foreach( path, :header_converters => :symbol  ) do |row|
      i += 1

      pp row if i == 1

      print '.' if i % 100 == 0

      ## for debuggin stop after 1000
      if i > 1000
      #   break
      end


      date   = row[:date]

      ## date is NA? - set to -  for not known
      date = nil    if date.empty? || date == 'NA'
      if date.nil?
        puts "!! ERROR: date missing in row:"
        pp row
        exit 1
      end


      year   = row[:season].to_i    ## note: it's always the season start year (only)

      team1  = row[:home]
      team2  = row[:visitor]

      ft     = row[:ft]
      ## note: for now round, and ht (half-time) results are always missing

       ## todo/check: change 3a to 3n (north) and 3b to 3s (south) - why? why not?
      division = row[:division]     # e.g. '1','2', '3a', '3b', ??

      if division.nil? || division.empty?
        puts "!! ERROR: division missing in row:"
        pp row
        exit 1
      end
      ## tier     = row[:tier].to_i    # e.g. 1,2,3

      ###
      #  for now skip all season starting 1993/14
      # if year >= 1993
      #  print '.' if i % 100 == 0
      #  next
      # end

      ##  for debugging - stop after 1894
      ## if year >= 1894
      ##  exit
      ## end


      values = []
      values << date
      values << team1
      values << ft
      values << team2

      divisions = years[ year ]         ||= {}
      recs      = divisions[ division ] ||= []
      recs   << values
end


puts
puts

years.each do |year, divisions|
  divisions.each do |division, recs|

    puts "#{year} - #{division} - #{recs.size} records"
  end
end


years.each do |year, divisions|

    ## convert to season as string e.g. 1899 to 1899-00 or 1911 to 1911-12 etc.
    season  = "%4d-%02d" % [year, (year+1)%100]
    century = "%2d00s" % (year/100)     # e.g. 1800s, 1900s, 2000s

    divisions.each do |division, recs|
      basename = "eng.#{division}"
      directory = "#{century}/#{season}"
      puts "write #{basename} (#{directory}) in #{out_root}"

      out_path = "#{out_root}/#{directory}/#{basename}.csv"

      ##   note:  sort matches by date before saving/writing!!!!
      ##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
      ## note: assume date is first column!!!
      recs = recs.sort { |l,r| l[0] <=> r[0] }
      ## reformat date / beautify e.g. Sat Aug 7 1993
      recs.each { |rec| rec[0] = Date.strptime( rec[0], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

      CsvMatchWriter.write( out_path, recs )
    end
end


puts 'done'
