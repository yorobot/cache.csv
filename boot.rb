## note: use the local version of sportdb-source gem

require_relative 'starter'
Starter.setup   # setup load path


##  just use sportdb/catalogs  ?! - why? why not?
# todo/fix - update require ?!
# require 'sportdb/importers'
require 'sportdb/readers'


### note: use local/relative to this file (e.g. use __FILE__) !!!
## todo/check: get (reuse) sites_dir from Starter - why? why not?
SITES_DIR =  File.expand_path( "#{File.dirname(__FILE__)}/../.." )

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SITES_DIR}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SITES_DIR}/openfootball/leagues"

# todo/fix - update require ?!
## todo/fix - do NOT preload COUNTRIES/LEAGUES/ etc. on require linters!!!
require 'sportdb/linters'    # e.g. uses TeamSummary class
require 'sportdb/writers'



####
# for testing
if __FILE__ == $0
  puts "SITES_DIR=>#{SITES_DIR}<"
  puts "bye"
end
