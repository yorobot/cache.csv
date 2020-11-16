## hack: use "local" sportdb-setup source too :-) for now
# $LOAD_PATH.unshift( 'C:/Sites/sportdb/sport.db/sportdb-setup/lib' )


## note: use the local version of sportdb-source gem
require 'sportdb/setup'
SportDb::Boot.setup   # setup dev (local) load path



require 'sportdb/catalogs'
##  just use sportdb/catalogs  ?! - why? why not?
# todo/fix - update require ?!
# require 'sportdb/importers'   # -- requires db support
# require 'sportdb/readers'     # -- requires db support


## require 'sportdb/writers'

## require 'sportdb/linters'    # e.g. uses TeamSummary class


## require 'sportdb/exporters'   ## requires db support


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SportDb::Boot.root}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SportDb::Boot.root}/openfootball/leagues"



####
# for testing
if __FILE__ == $0
  puts "SportDb::Boot.root=>#{SportDb::Boot.root}<"
  puts "bye"
end
