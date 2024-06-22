require_relative 'helper'



SportDb.open_mem   ## use (setup) in memory db

SportDb.read( '../../../openfootball/copa-america/2024--usa/copa.txt' ) 


puts "table stats:"
SportDb.tables



SportDb::JsonExporter.export_copa( 'southamerica', out_root: './tmp/json/copa' )


### copy to copa-america.json repo

require 'fileutils'

src  = './tmp/json/copa/2024/copa.json'
dest = '/sports/openfootball/copa-america.json/2024/copa.json' 
FileUtils.cp( src, dest )




puts "bye"


