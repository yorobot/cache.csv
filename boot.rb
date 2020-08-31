## hack: use "local" dev monoscript too :-) for now
$LOAD_PATH.unshift( 'C:/Sites/yorobot/cache.csv/monoscript/lib' )

## note: use the local version of sportdb-source gem
require 'mono/sportdb'
Mono.setup   # setup load path



##  just use sportdb/catalogs  ?! - why? why not?
# todo/fix - update require ?!
# require 'sportdb/importers'   # -- requires db support
# require 'sportdb/readers'     # -- requires db support
require 'sportdb/catalogs'



require 'sportdb/linters'    # e.g. uses TeamSummary class

## require 'sportdb/writers'


## require 'sportdb/exporters'   ## requires db support


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{Mono.root}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{Mono.root}/openfootball/leagues"



####
# for testing
if __FILE__ == $0
  puts "Mono.root=>#{Mono.root}<"
  puts "bye"
end
