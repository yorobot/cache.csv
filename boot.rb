## note: use the local version of sportdb-source gem

require_relative 'starter'
Starter.setup   # setup load path


##  just use sportdb/catalogs  ?! - why? why not?
# todo/fix - update require ?!
# require 'sportdb/importers'   # -- requires db support
# require 'sportdb/readers'     # -- requires db support
require 'sportdb/catalogs'



require 'sportdb/linters'    # e.g. uses TeamSummary class

require 'sportdb/writers'


## require 'sportdb/exporters'   ## requires db support



### note: use local/relative to this file (e.g. use __FILE__) !!!
## todo/check: get (reuse) sites_dir from Starter - why? why not?
SITES_DIR =  File.expand_path( "#{File.dirname(__FILE__)}/../.." )

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SITES_DIR}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SITES_DIR}/openfootball/leagues"



####
# for testing
if __FILE__ == $0
  puts "SITES_DIR=>#{SITES_DIR}<"
  puts "bye"
end
