

########################
#  push & pull github scripts


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


