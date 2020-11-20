#############
## todo/fix:  reuse  a "original" CsvMatchWriter
##                  how? why? why not?
###############
module Cache
class CsvMatchWriter
  def self.csv_encode( values )
    ## quote values that incl. a comma
    values.map do |value|
      if value.index(',')
        puts "** rec with field with comma >#{value}< in:"
        pp values
        %Q{"#{value}"}
      else
        value
      end
    end.join( ',' )
  end


    def self.write( path, recs, headers: )

      ## for convenience - make sure parent folders/directories exist
      FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

        File.open( path, 'w:utf-8' ) do |f|
          f.write( headers.join(','))   ## e.g. Date,Team 1,FT,HT,Team 2
          f.write( "\n" )
          recs.each do |values|
              f.write( csv_encode( values ))
              f.write( "\n" )
          end
        end
    end

end # class CsvMatchWriter
end # module Cache




def build( rows, league:, season: )
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  raise ArgumentError, "league key as string expected"  unless league.is_a?(String)  ## note: do NOT pass in league struct! pass in key (string)

  print "  #{rows.size} rows - build #{league} #{season}"
  print "\n"


  recs = []
  rows.each do |row|

    stage  =  row[:stage] || ''

    ## todo/check:  assert that only matchweek or round can be present NOT both!!
    round  =  if row[:matchweek] && row[:matchweek].size > 0
                row[:matchweek]
              elsif row[:round] && row[:round].size > 0
                row[:round]
              else
                ''
              end

    date_str  = row[:date]
    time_str  = row[:time]
    team1_str = row[:team1]
    team2_str = row[:team2]
    score_str = row[:score]

    ## convert date from string e.g. 2019-25-10
    date = Date.strptime( date_str, '%Y-%m-%d' )

    comments = row[:comments]
    ht, ft, et, pen, comments = parse_score( score_str, comments )


    venue_str =      row[:venue]
    attendance_str = row[:attendance]


    recs <<  [stage,
              round,
              date.strftime( '%Y-%m-%d' ),
              time_str,
              team1_str,
              ft,
              ht,
              team2_str,
              et,              # extra: incl. extra time
              pen,             # extra: incl. penalties
              venue_str,
              attendance_str,
              comments]
  end

  recs
end




def parse_score( score_str, comments )

  ## split score
  ft  = ''
  ht  = ''
  et  = ''
  pen = ''

  if score_str.size > 0
    ## note: replace unicode "fancy" dash with ascii-dash
    #  check other columns too - possible in teams?
    score_str = score_str.gsub( /[–]/, '-' ).strip

    if score_str =~ /^\(([0-9]+)\)
                        [ ]+ ([0-9]+) - ([0-9+]) [ ]+
                      \(([0-9]+)\)$/x
      ft  = '?'
      et  = "#{$2}-#{$3}"
      pen = "#{$1}-#{$4}"
    else  ## assume "regular" score e.g. 0-0
          ## check if notes include extra time otherwise assume regular time
      if comments =~ /extra time/i
        ft = '?'
        et = score_str
      else
        ft = score_str
      end
    end
  end

  [ht, ft, et, pen, comments]
end



MAX_HEADERS = [
'Stage',
'Round',
'Date',
'Time',
'Team 1',
'FT',
'HT',
'Team 2',
'ET',
'P',
'Venue',
'Att',
'Comments',    ## e.g. awarded, cancelled/canceled, etc.
]

MIN_HEADERS = [   ## always keep even if all empty
'Date',
'Team 1',
'FT',
'Team 2'
]

def vacuum( rows, headers: MAX_HEADERS, fixed_headers: MIN_HEADERS )
  ## check for unused columns and strip/remove
  counter = Array.new( MAX_HEADERS.size, 0 )
  rows.each do |row|
     row.each_with_index do |col, idx|
       counter[idx] += 1  unless col.nil? || col.empty?
     end
  end

  pp counter

  ## check empty columns
  headers       = []
  indices       = []
  empty_headers = []
  empty_indices = []

  counter.each_with_index do |num, idx|
     header = MAX_HEADERS[ idx ]
     if num > 0 || (num == 0 && fixed_headers.include?( header ))
       headers << header
       indices << idx
     else
       empty_headers << header
       empty_indices << idx
     end
  end

  if empty_indices.size > 0
    rows = rows.map do |row|
             row_vacuumed = []
             row.each_with_index do |col, idx|
               ## todo/fix: use values or such??
               row_vacuumed << col   unless empty_indices.include?( idx )
             end
             row_vacuumed
         end
    end

  [rows, headers]
end
