
class GitError < StandardError
end

class Git   ## make Git a module - why? why not?

  ###
  ## todo/fix:  change opts=nil to *args or such - why? why not?


  ###############
  ## "setup" starter git commands

  def self.clone( repo, opts=nil )
    cmd = "git clone #{repo}"
    ## todo/fix: check if options MUST go before repo arg?
    ##   just use *args and args.join(' ') or such why? why not?
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end

  def self.mirror( repo, opts=nil )
    cmd = "git clone --mirror #{repo}"
    ## todo/fix: check if options MUST go before repo arg?
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end


  #################
  ## standard git commands

  def self.version
    cmd = 'git --version'
    Shell.run( cmd )
  end

  def self.status( opts=nil )
    cmd = 'git status'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end

  def self.changes( opts=nil )  ## same as git status --short  - keep shortcut / alias - why? why not?
    ## returns changed files - one per line or empty if no changes
    cmd = 'git status --short'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end

  #####################
  ## status helpers

  ## git status --short  returns empty stdout/list
  def self.clean?()   changes.empty?; end

  def self.changes?() clean? == false; end  ## reverse of clean?
  class << self
    alias_method :dirty?, :changes?  ## add alias
  end


  #######
  ## more (major) git commands

  def self.pull( opts=nil )
    cmd = 'git pull'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end

  def self.fast_forward( opts=nil )
    cmd = 'git pull --ff-only'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end
  class << self
    alias_method :ff, :fast_forward   ## add alias
  end


  def self.push( opts=nil )
    cmd = 'git push'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end

  def self.add( opts=nil )
    cmd = 'git add'
    cmd << " #{opts}"   unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end

  def self.commit( opts=nil, message: nil )
    cmd = 'git commit'
    cmd << %Q{ -m "#{message}"}  unless message.nil? || message.empty?
    cmd << " #{opts}"            unless opts.nil? || opts.empty?
    Shell.run( cmd )
  end


###
#  use nested class for "base" for running commands - why? why not?
class Shell
def self.run( cmd )
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
    ## todo/check: or use >2: or &2: or such
    ##  stderr output not always an error (that is, exit status might be 0)
    puts "STDERR:"
    puts stderr
  end

  if status.success?
    stdout   # return stdout string
  else
    puts "!! ERROR: cmd exec >#{cmd}< failed with exit status #{status.exitstatus}:"
    puts stderr
    raise GitError, "git cmd exec >#{cmd}< failed with exit status #{status.exitstatus}<: #{stderr}"
  end
end
end # class Shell

end # class Git



class GitRepo
  def self.open( path, &blk )
    new( path ).open( &blk )
  end

  def initialize( path )
    raise ArgumentError, "dir >#{path}< not found; dir MUST already exist for GitRepo class - sorry"   unless Dir.exist?( path )
    @path = path
  end

  def open( &blk )
    ## puts "Dir.getwd: #{Dir.getwd}"
    Dir.chdir( @path ) do
      blk.call( self )
    end
    ## puts "Dir.getwd: #{Dir.getwd}"
  end


  def status( opts=nil )        Git.status( opts ); end
  def changes( opts=nil )       Git.changes( opts ); end
  def clean?()                  Git.clean?; end
  def changes?()                Git.changes?; end
  alias_method :dirty?, :changes?

  def pull( opts=nil )          Git.pull( opts ); end
  def fast_forward( opts=nil )  Git.fast_forward( opts ); end
  alias_method :ff, :fast_forward

  def push( opts=nil )          Git.push( opts ); end

  def add( opts=nil )           Git.add( opts ); end
  def commit( opts=nil, message: nil )
    Git.commit( opts, message: message )
  end


end # class GitRepo
