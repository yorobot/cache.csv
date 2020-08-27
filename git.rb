############
#  push github


def git_push( path, msg )
  ## todo/fix:
  ##  check if any changes (only push if changes commits - how??)

  ## msg  ="auto-update week #{Date.today.cweek}"

  puts "Dir.getwd: #{Dir.getwd}"
  Dir.chdir( path ) do
    ## trying to update
    puts ''
    puts "###########################################"
    puts "## trying to commit & push repo in path >#{path}<"
    puts "Dir.getwd: #{Dir.getwd}"
    result = system( "git status" )
    pp result
    result = system( "git add ." )
    pp result
    result = system( %Q{git commit -m "#{msg}"} )
    pp result
    result = system( "git push" )
    pp result
    ## todo/fix: check return code !!!!
  end
  puts "Dir.getwd: #{Dir.getwd}"
end

