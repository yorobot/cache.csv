## startup helper

require_relative '../starter'
Starter.setup   ## setup dev load path


require_relative 'lib/write'


### note: use local/relative to this file (e.g. use __FILE__) !!!
## todo/check: get (reuse) sites_dir from Starter - why? why not?
SITES_DIR =  File.expand_path( "#{File.dirname(__FILE__)}/../../.." )

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SITES_DIR}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SITES_DIR}/openfootball/leagues"

