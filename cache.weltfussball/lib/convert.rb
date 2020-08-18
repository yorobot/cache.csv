###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies


require_relative 'metal'


$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/date-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/score-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sports/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib') )
$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-catalogs/lib') )
# require 'sportdb/formats'   ## for Season etc.
require 'sportdb/catalogs'


require_relative '../../csv'

require_relative '../config'


## our own code
require_relative 'convert/download'
require_relative 'convert/build'
require_relative 'convert/convert'
require_relative 'convert/convert_reports'



