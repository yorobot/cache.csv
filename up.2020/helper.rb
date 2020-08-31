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



## hack: use "local" dev monoscript too :-) for now
$LOAD_PATH.unshift( 'C:/Sites/yorobot/cache.csv/monoscript/lib' )

require 'mono/sportdb'
Mono.setup   ## setup dev load path



require_relative '../cache.weltfussball/lib/convert'
require_relative '../writer/lib/write'


## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{Mono.root}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{Mono.root}/openfootball/leagues"



################################
# add more helpers
#  move upstream for (re)use - why? why not?

## todo/check: what to do: if league is both included and excluded?
##   include forces include? or exclude has the last word? - why? why not?
##  Excludes match before includes,
##   meaning that something that has been excluded cannot be included again

def download_pages( leagues, season,
                      includes: nil,
                      excludes: nil )
  leagues.each do |league|
    next  if excludes && excludes.find { |q| league.start_with?( q ) }
    next  if includes && includes.find { |q| league.start_with?( q ) }.nil?

    puts "downloading #{league} #{season}..."

    Worldfootball.schedule( league: league, season: season )
  end
end


## todo - find "proper/classic" timezone ("winter time")

##  Brasilia - Distrito Federal, Brasil  (GMT-3)  -- summer time?
##  Ciudad de México, CDMX, México       (GMT-5)  -- summer time?
##  Londres, Reino Unido (GMT+1)
##   Madrid -- ?
##   Lisboa -- ?
##   Moskow -- ?
##
## todo/check - quick fix timezone offsets for leagues for now
##   - find something better - why? why not?
## note: assume time is in GMT+1
OFFSETS = {
  'eng.1' => -1,
  'eng.2' => -1,
  'eng.3' => -1,
  'eng.4' => -1,
  'eng.5' => -1,

  # 'es.1',       # starts ??

  'br.1'  => -5,
  'mx.1'  => -7,
}

def convert( leagues, season,
               includes: nil,
               excludes: nil )
  leagues.each do |league|
    next  if excludes && excludes.find { |q| league.start_with?( q ) }
    next  if includes && includes.find { |q| league.start_with?( q ) }.nil?

    Worldfootball.convert( league: league,
                           season: season,
                           offset: OFFSETS[ league ] )
  end
end

##
## todo/check:  remove default for source to make it more "generic" / less magic - why? why not?
##   or move this write into Worldfootball?
def write( leagues, season,
             source:   Worldfootball.config.convert.out_dir,
             includes: nil,
             excludes: nil )
  leagues.each do |league|
    next  if excludes && excludes.find { |q| league.start_with?( q ) }
    next  if includes && includes.find { |q| league.start_with?( q ) }.nil?

    Writer.write( league, season, source: source )
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
    path = "#{Mono.root}/openfootball/#{name}"

    GitRepo.open( path ) do |git|
      puts ''
      puts "###########################################"
      puts "## trying to commit & push repo in path >#{path}<"
      puts "Dir.getwd: #{Dir.getwd}"
      output = git.status( '--short' )
      if output.empty?
        puts "no changes found; skipping commit & push"
      else
        git.add( '.' )
        git.commit( message: message )
        git.push
      end
    end
  end
end


def git_fast_forward_if_clean( names )
  names.each do |name|
    path = "#{Mono.root}/openfootball/#{name}"

    GitRepo.open( path ) do |git|
      output = git.status( '--short' )
      unless  output.empty?
        puts "FAIL - cannot git pull (fast-forward) - working tree has changes:"
        puts output
        exit 1
      end

      git.fast_forward
   end
  end
end

