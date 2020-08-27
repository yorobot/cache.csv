##  just use sportdb/catalogs  ?! - why? why not?
#  require 'sportdb/importers'   # -- requires db support
#  require 'sportdb/readers'     # -- requires db support
require 'sportdb/catalogs'


require 'sportdb/writers'



### our own code
require_relative 'write/config'
require_relative 'write/write'

require_relative 'write/leagues'
require_relative 'write/leagues_eng'
require_relative 'write/leagues_de'
require_relative 'write/leagues_at'
require_relative 'write/leagues_world'


