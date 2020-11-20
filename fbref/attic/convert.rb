
class Writer

MAX_HEADERS = [
  'stage',
  'round',
  'matchweek',   # was gameweek - rename to matchday/matchweek - why? why not?
  'dayofweek',
  'date',
  'time',
  'team1',       # was squad_a  - rename to team_a/team_1  - why? why not?
  'score',
  'team2',       # was squad_b  - rename to team_b/team_2  - why? why not?
  'attendance',
  'venue',
  'referee',
  'notes',
  'match_report',
]

def self.headers( rows, headers: MAX_HEADERS )
  ## check for unused columns and strip/remove
  counter = Hash.new(0)

  rows.each do |row|
     row.each do |key, value|
       counter[key] += 1  unless value.nil? || value.empty?
     end
  end
  pp counter


  ## report/exit if unknown header found !!
  headers = headers.map { |key| key.to_sym }  ## symbolize keys/header names for now
  unknown_headers = counter.keys.select { |key| headers.include?( key ) == false }
  if unknown_headers.size > 0
    puts "!! ERROR - #{unknown_headers.size} unknown headers:"
    pp unknown_headers
    exit 1
  end

  ## calculate (used) headers;
  used_headers = []
  headers.each do |header|
     if counter[ header ] > 0
      used_headers << header
     else
       puts "  skipping unused header/column >#{header}<"
     end
  end

  used_headers
end



def self.csv_encode( values )
  ## quote values that incl. a comma
  values.map do |value|
    if value.index(',')
      puts "** rec with field with comma: >#{value}<"
      ## pp values
      %Q{"#{value}"}
    else
      value
    end
  end.join( ',' )
end

def self.write( path, rows )
  headers = headers( rows )
  pp headers

  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( headers.join( ',' ))
    f.write( "\n" )
    rows.each do |row|
      values = headers.map {|key| row[key] || '' }
      f.write( csv_encode( values ) )
      f.write( "\n" )
    end
  end
end

end # class Writer
