## note: use the local version of gems

sportdb_dir      ='../../../sportdb/sport.db'
sportdb_more_dir ='../../../yorobot/sport.db.more'

$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-langs/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-structs/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-catalogs/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-formats/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-readers/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-sync/lib" ))
$LOAD_PATH.unshift( File.expand_path( "#{sportdb_dir}/sportdb-models/lib" ))


## our own code
require 'sportdb/catalogs'   ## catalogs pulls in formats (again)
require 'sportdb/readers'


$LOAD_PATH.unshift( "#{sportdb_more_dir}/sportdb-exporters/lib" )
require "sportdb/exporters"



SportDb::Import.config.catalog_path = "#{sportdb_dir}/catalog/catalog.db"

CatalogDb::Metal.tables


