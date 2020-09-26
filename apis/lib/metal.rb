###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies



require 'pp'
require 'time'
require 'date'
require 'json'
require 'net/http'
require 'uri'
require 'fileutils'



## our own code
require_relative 'metal/config'
require_relative 'metal/download'


