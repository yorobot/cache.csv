require_relative '../boot'


DATAFILES_DIR = '../../../footballcsv/cache.footballdata'


team_buf,   team_errors   = SportDb::TeamSummary.build( DATAFILES_DIR )
season_buf, season_errors = SportDb::SeasonSummary.build( DATAFILES_DIR )


OUT_DIR = DATAFILES_DIR
# OUT_DIR  = './o'   ## for (local) debugging

File.open( "#{OUT_DIR}/SUMMARY.md", 'w:utf-8' )  { |f| f.write( team_buf ) }
File.open( "#{OUT_DIR}/CHECKSUM.md", 'w:utf-8' ) { |f| f.write( season_buf ) }



puts "#{team_errors.size} error(s) - teams:"
pp team_errors

puts "#{season_errors.size} error(s) - seasons:"
pp season_errors


puts 'bye'
