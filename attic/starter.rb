##########
#  setup load path
#     lets you use environments
#     e.g. dev/development or production

require 'pp'


module Starter

  def self.root
    File.expand_path( File.dirname(__FILE__) )
  end

  def self.setup   ## setup load path
### note: for now always assume dev/development
###   add ENV check later or pass in as args or such

    ## todo/check: find a better name - use repos_dir or source_dir or such? why? why not?
    sites_dir = File.expand_path( "#{root}/../.." )
    puts "root:      >#{root}<"
    puts "sites_dir: >#{sites_dir}<"


    $LOAD_PATH.unshift( "#{sites_dir}/yorobot/sport.db.more/sportdb-exporters/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/yorobot/sport.db.more/sportdb-writers/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/yorobot/sport.db.more/sportdb-linters/lib" )

    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/sports/lib" )

    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/sportdb-importers/lib" )
    ## todo - add readers, models, sync, etc.

    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/sportdb-catalogs/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/sportdb-formats/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/sportdb-structs/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/sportdb-langs/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/score-formats/lib" )
    $LOAD_PATH.unshift( "#{sites_dir}/sportdb/sport.db/date-formats/lib" )


    pp $:  # print load path
  end
end # module Starter



####
# for testing

if __FILE__ == $0
  Starter.setup
  puts "bye"
end
