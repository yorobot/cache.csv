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



require_relative '../starter'
Starter.setup   ## setup dev load path


require_relative '../cache.weltfussball/lib/convert'
require_relative '../writer/lib/write'

### note: use local/relative to this file (e.g. use __FILE__) !!!
## todo/check: get (reuse) sites_dir from Starter - why? why not?
SITES_DIR =  File.expand_path( "#{File.dirname(__FILE__)}/../../.." )

## use (switch to) "external" datasets
SportDb::Import.config.clubs_dir   = "#{SITES_DIR}/openfootball/clubs"
SportDb::Import.config.leagues_dir = "#{SITES_DIR}/openfootball/leagues"



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




require_relative '../git'


def push( names )   ## optenfootball repo names e.g. world, england, etc.
  msg = "auto-update week #{Date.today.cweek}"
  puts msg

  names.each do |name|
    path = "#{SITES_DIR}/openfootball/#{name}"
    git_push( path, msg )
  end
end

def fast_forward_if_clean( names )
  names.each do |name|
    path = "#{SITES_DIR}/openfootball/#{name}"
    git_fast_forward_if_clean( path )
  end
end


### todo/fix:
##  try to capture output ?? and check if no changes
##   present on pull ???

### use git status with short format for easier capture??


=begin

>> git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
>> git pull --ff-only
Already up to date.



###########################################
## trying to commit & push repo in path >C:/Sites/openfootball/mexico<
Dir.getwd: C:/Sites/openfootball/mexico
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   2020-21/1-apertura.txt

no changes added to commit (use "git add" and/or "git commit -a")
true
true
[master 52bc88f] auto-update week 35
 1 file changed, 4 insertions(+), 4 deletions(-)
true
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 2 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 421 bytes | 84.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:openfootball/mexico.git
   5ee65ad..52bc88f  master -> master
true
=end
