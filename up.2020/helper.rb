## startup helper

# puts "$0            : #{$0}"              #=> "./top.rb"
# puts "$PROGRAM_NAME : #{$PROGRAM_NAME}"   #=> "./top.rb"
# puts "__FILE__      : #{__FILE__}"        #=> "C:/Sites/yorobot/cache.csv/up.2020/helper.rb"

## get program name WITHOUT path and extension
##  e.g. ./top.rb  =>  top
## todo: find a better name
##   - use SCRIPT or PROGRAM_BASENAME or such - why? why not?
NAME = File.basename( $PROGRAM_NAME, File.extname( $PROGRAM_NAME ))

puts "NAME          : #{NAME}"



### todo/fix:
##    add option for -e/--env(ironment)
##      - lets you toggle between dev/prod/etc.


require 'optparse'

puts "-- optparse:"

OPTS = {}
optparser = OptionParser.new do |opts|
  opts.banner = "Usage: #{NAME} [options]"

  opts.on( "-d", "--download", "Download web pages" ) do |download|
    OPTS[:download] = download
  end

  opts.on( "-p", "--push", "(Commit &) push changes to git" ) do |push|
    OPTS[:push] = push
  end

end
optparser.parse!

puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts



###
## fix - remove Mono ?? just use gitti only - why? why not?
require 'mono'

## hack: use "local" sportdb-setup source too :-) for now
$LOAD_PATH.unshift( 'C:/Sites/sportdb/sport.db/sportdb-setup/lib' )

require 'sportdb/setup'
SportDb::Boot.setup   ## setup dev load path



require_relative '../cache.weltfussball/lib/convert'
require_relative '../writer/lib/write'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SportDb::Boot.root}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SportDb::Boot.root}/openfootball/leagues"



##
## todo/check:  remove default for source to make it more "generic" / less magic - why? why not?
##   or move this write into Worldfootball?
def write( datasets,
             source:   Worldfootball.config.convert.out_dir,
             includes: nil,
             excludes: nil )
  datasets.each do |dataset|
    league  = dataset[0]
    seasons = dataset[1]

    next  if excludes && excludes.find { |q| league.start_with?( q.downcase ) }
    next  if includes && includes.find { |q| league.start_with?( q.downcase ) }.nil?

    seasons.each do |season|
      Writer.write( league, season, source: source )
    end
  end
end




###
## todo/fix:
##   add -i/--interactive flag
##     will prompt yes/no  before git operations (with consequences)!!!



########################
#  push & pull github scripts




## todo/fix: rename to something like
##    git_(auto_)commit_and_push_if_changes/if_dirty()

def git_push_if_changes( names )   ## optenfootball repo names e.g. world, england, etc.
  message = "auto-update week #{Date.today.cweek}"
  puts message

  names.each do |name|
    path = "#{SportDb::Boot.root}/openfootball/#{name}"

    Gitti::GitProject.open( path ) do |proj|
      puts ''
      puts "###########################################"
      puts "## trying to commit & push repo in path >#{path}<"
      puts "Dir.getwd: #{Dir.getwd}"
      output = proj.changes
      if output.empty?
        puts "no changes found; skipping commit & push"
      else
        proj.add( '.' )
        proj.commit( message )
        proj.push
      end
    end
  end
end


def git_fast_forward_if_clean( names )
  names.each do |name|
    path = "#{SportDb::Boot.root}/openfootball/#{name}"

    Gitti::GitProject.open( path ) do |proj|
      output = proj.changes
      unless  output.empty?
        puts "FAIL - cannot git pull (fast-forward) - working tree has changes:"
        puts output
        exit 1
      end

      proj.fast_forward
   end
  end
end



###
## todo/fix:  move more code into tool class or such? - why? why not?

def process( datasets, repos, includes: )
  ## quick fix: move/handle empty array upstream!!!!
  includes = nil   if includes.is_a?(Array) && includes.empty?


  tool = Worldfootball::Tool.new(
                         includes: includes )


  tool.download( datasets )  if OPTS[:download]

  ## always pull before push!! (use fast_forward)
  git_fast_forward_if_clean( repos )  if OPTS[:push]


  # Worldfootball.config.convert.out_dir = './o/aug29'
  Worldfootball.config.convert.out_dir = './o'

  tool.convert( datasets )


  if OPTS[:push]
    Writer.config.out_dir = "#{SportDb::Boot.root}/openfootball"
  else
    Writer.config.out_dir = './tmp'
  end

  write( datasets, includes: includes )


  ## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
  git_push_if_changes( repos )    if OPTS[:push]

  puts "INCLUDES:"
  pp includes
  puts "REPOS:"
  pp repos
end

