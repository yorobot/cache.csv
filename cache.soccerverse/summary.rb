require_relative '../boot'



DATAFILES_DIR = '../../../footballcsv/cache.soccerverse'
# DATAFILES_DIR = './o'   ## for (local) debugging

buf, errors = SportDb::TeamSummary.build( DATAFILES_DIR, start: '1989' )

puts "#{errors.size} errors:"
pp errors


File.open( "#{DATAFILES_DIR}/SUMMARY.md", 'w:utf-8' ) do |f|
  f.write buf
end

puts 'bye'