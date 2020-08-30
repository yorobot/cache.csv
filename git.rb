require 'open3'


########################
#  push & pull github scripts


class Git   ## todo/fix: change to GitRepo  - why? why not?
  def self.open( path, &blk )
    new( path ).open( &blk )
  end

  def initialize( path )
    @path = path
  end

  def open( &blk )
    puts "Dir.getwd: #{Dir.getwd}"
    Dir.chdir( @path ) do
      blk.call( self )
    end
    puts "Dir.getwd: #{Dir.getwd}"
  end

  ## standard git commands
  def status( opts='' )
    cmd = 'git status'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    exec_cmd( cmd )
  end

  def pull( opts='' )
    cmd = 'git pull'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    exec_cmd( cmd )
  end

  def push( opts='' )
    cmd = 'git push'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    exec_cmd( cmd )
  end

  def add( opts='' )
    cmd = 'git add'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    exec_cmd( cmd )
  end

  def commit( opts='' )
    cmd = 'git commit'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    exec_cmd( cmd )
  end

private

def exec_cmd( cmd )
  print "cmd exec >#{cmd}<..."
  stdout, stderr, status = Open3.capture3( cmd )

  if status.success?
    print " OK"
    print "\n"
  else
    print " FAIL (#{status.exitstatus})"
    print "\n"
  end

  unless stdout.empty?
    puts stdout
  end

  unless stderr.empty?
    puts "STDERR:"
    puts stderr
  end

  if status.success?
    stdout   # return stdout string
  else
    puts "!! ERROR: cmd exec >#{cmd}< failed with exit status #{status.exitstatus}:"
    puts stderr
    exit 1
  end
end

end # class Git



def git_fast_forward_if_clean( path )   ## todo/find a better name e.g. uptodate or pull - why? why not?
  ## check for remote changes/updates - use pull
  ##
  Git.open( path ) do |git|
     ## 1) check for status
     ##   assume clean
     stdout = git.status( '--short' )
     unless  stdout.empty?
       puts "FAIL - cannot git pull (fast-forward) - working tree has changes:"
       puts stdout
       exit 1
     end

     git.pull( '--ff-only' )
  end
end



def git_push( path, msg )
  ## msg  ="auto-update week #{Date.today.cweek}"

  Git.open( path ) do |git|
    ## trying to update
    puts ''
    puts "###########################################"
    puts "## trying to commit & push repo in path >#{path}<"
    puts "Dir.getwd: #{Dir.getwd}"
    stdout = git.status( '--short' )
    if stdout.empty?
      puts "no changes found; skipping commit & push"
    else
      git.add( '.' )
      git.commit( %Q{-m "#{msg}"} )
      git.push
    end
  end
end


