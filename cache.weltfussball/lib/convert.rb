###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies


require_relative 'metal'


# require 'sportdb/formats'   ## for Season etc.
require 'sportdb/catalogs'


require_relative '../../csv'




## our own code
require_relative 'convert/leagues'

require_relative 'convert/config'

require_relative 'convert/download'

require_relative 'convert/mods'
require_relative 'convert/vacuum'
require_relative 'convert/build'
require_relative 'convert/convert'
require_relative 'convert/convert_reports'



