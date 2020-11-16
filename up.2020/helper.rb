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

require 'pp'
require 'optparse'

puts "-- optparse:"

OPTS = {}
parser = OptionParser.new do |parser|
  parser.banner = "Usage: #{NAME} [options]"

  parser.on( "-d", "--download", "Download web pages" ) do |download|
    OPTS[:download] = download
  end

  parser.on( "-p", "--push", "(Commit &) push changes to git" ) do |push|
    OPTS[:push] = push
  end

end
parser.parse!

puts "OPTS:"
p OPTS
puts "ARGV:"
p ARGV

puts "-------"
puts




## hack: use "local" sportdb-setup source too :-) for now
# $LOAD_PATH.unshift( 'C:/Sites/sportdb/sport.db/sportdb-setup/lib' )

require 'sportdb/setup'
SportDb::Boot.setup   ## setup dev load path


require 'sportdb/catalogs'

## use (switch to) "external" datasets
SportDb::Import.config.leagues_dir = "#{SportDb::Boot.root}/openfootball/leagues"
SportDb::Import.config.clubs_dir   = "#{SportDb::Boot.root}/openfootball/clubs"


## more libs / gems
require 'sportdb/writers'

require 'football/sources'    ## download & convert football data





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
require 'gitti'

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

## todo/check: find a better name for helper?
##   find_leagues_in (datasets) ???
##  queries (lik ARGV) e.g. ['at'] or ['eng', 'de'] etc. list of strings
def find_leagues( datasets, queries=[] )
  ## find all matching leagues (that is, league keys)
  if queries.empty?  ## no filter - get all league keys
    leagues = datasets.map { |dataset| dataset[0] }
  else
    leagues = []
    queries.each do |q|
      more_leagues = datasets
                       .map { |dataset| dataset[0] }
                       .find_all {|league| league.start_with?( q.downcase ) }
      leagues += more_leagues  if more_leagues
    end
    ## todo/check: filter out (possible) duplicates - why? why not?
  end
  leagues
end

## todo/check: find a better name for helper?
def find_repos( leagues )
  repos = []
  leagues.each do |league|
    league_info = Writer::LEAGUES[ league ]
    pp league_info
    path = league_info[:path]

    ## use only first part e.g. europe/belgium => europe
    repos << path.split( %r{[/\\]})[0]
  end
  pp repos
  repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end


def process( datasets, includes: )

  ## expand includes (e.g. at matchting at.1,at.2,at.cup with start_with etc.)
  ## find all repo paths (e.g. england or europe)
  ##   from league code e.g. eng.1, be.1, etc.
  leagues = find_leagues( datasets, includes )
  repos   = find_repos( leagues )



  ## fix: pass along list of expand league keys
  ##        (not includes query/array of strings) - why? why not?

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

  puts "INCLUDES (QUERIES):"
  pp includes
  puts "LEAGUES:"
  pp leagues
  puts "REPOS:"
  pp repos
end

