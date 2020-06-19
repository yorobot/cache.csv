require_relative '../boot'



# DATAFILES_DIR = '../../footballcsv/cache.soccerdata'
DATAFILES_DIR = './o'

buf, errors = SportDb::TeamSummary.build( DATAFILES_DIR, start: '1989' )

puts "#{errors.size} errors:"
pp errors

path = "#{DATAFILES_DIR}/SUMMARY.md"
# path = './o/SUMMARY.md'   ## for (local) debugging

File.open( path, 'w:utf-8' ) do |f|
  f.write buf
end

puts 'bye'