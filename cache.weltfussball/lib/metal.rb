###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies


## 3rd party (our own)
require_relative '../../cachedb/lib/webcache'    ## note: incl. (web) fetcher too

## 3rd party
require 'nokogiri'



## our own code
require_relative 'metal/config'
require_relative 'metal/download'
require_relative 'metal/page'
require_relative 'metal/page_schedule'
require_relative 'metal/page_report'


