## note: use the local version of sportdb-source gem
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/date-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/score-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sports/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-catalogs/lib') )


##  just use sportdb/catalogs  ?! - why? why not?
# todo/fix - update require ?!
# $LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-importers/lib') )
# require 'sportdb/importers'
require 'sportdb/readers'

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "../../../openfootball/clubs"
SportDb::Import.config.leagues_dir = "../../../openfootball/leagues"

# todo/fix - update require ?!
$LOAD_PATH.unshift( File.expand_path( '../../sport.db.more/sportdb-linters/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../sport.db.more/sportdb-writers/lib') )
require 'sportdb/linters'    # e.g. uses TeamSummary class
require 'sportdb/writers'

