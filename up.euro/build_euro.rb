require_relative 'helper'


database_path = './euro2024.db'

File.delete( database_path )   if File.exist?( database_path )



## todo/fix:
## add SportDb.open_mem ??
##        check what exists???
##        or open_memory or open_in_memory??


SportDb.open( database_path )
SportDb.read( '../../../openfootball/euro/2024--germany/euro.txt' ) 


puts "table stats:"
SportDb.tables


##
## generate json

SportDb::Model::Event.order( :id ).each do |event|
    puts "    #{event.key} | #{event.league.key} - #{event.league.name} | #{event.season.key}"
end


SportDb::JsonExporter.export_euro( 'euro', out_root: './tmp/json/euro' )


### copy to euro.json repo

require 'fileutils'

src  = './tmp/json/euro/2024/euro.json'
dest = '/sports/openfootball/euro.json/2024/euro.json' 
FileUtils.cp( src, dest )


puts "bye"


__END__

euro.1960 | euro - Euro | 1960
euro.1964 | euro - Euro | 1964
euro.1968 | euro - Euro | 1968
euro.2008 | euro - Euro | 2008
euro.2012 | euro - Euro | 2012
euro.2016 | euro - Euro | 2016
euro.2021 | euro - Euro | 2021
euro.2024 | euro - Euro | 2024



puts "bye"

