require 'pp'


###
## todo: turn into NotesSummary or NotesPage or something!!!!



# exclude pattern
  ##  for now exclude all files in directories starting with a dot (e.g. .git/ or .github/ or .build/ etc.)
  ##  todo/check: rename to EXCLUDE_DOT_DIRS_RE - why? why not?
  EXCLUDE_RE = %r{  (?: ^|/ )               # beginning (^) or beginning of path (/)
                        \.[a-zA-Z0-9_-]+  ## (almost) any name BUT must start with dot e.g.  .git, .build, etc.
                        /
                     }x

package_dir =  '../../../openfootball/brazil'
# package_dir =  '../../../openfootball/europe-champions-league'
# package_dir =  '../../../openfootball/russia'
# package_dir =  '../../../openfootball/espana'
# package_dir =  '../../../openfootball/france'
# package_dir =  '../../../openfootball/italy'
# package_dir =  '../../../openfootball/england'
# package_dir =  '../../../openfootball/austria'
# package_dir =  '../../../openfootball/deutschland'
datafiles = Dir.glob( "#{package_dir}/**/{*,.*}.txt" )

## filter
##   note: exclude /squads/ for now too
datafiles = datafiles.select do |datafile|
  if EXCLUDE_RE.match( datafile )
    false
  else
    if datafile =~ %r{/squads/}    ||
       datafile =~ %r{\.conf\.txt} ||     ## note: skip configs for now too
       datafile =~ %r{clubs\.props\.txt}
      false
    else
      true
    end
  end
end

## sort
datafiles = datafiles.sort

## pp datafiles


## todo/fix: add new "liberal" goal rule
##     MUST start with [
##  or MUST end with ]
##    and include player name and number e.g.
##
## (line =~ /^[ ]*\[/ && line =~ )     ## starts with [
##                        ## ends with ]


buf = String.new( '' )

datafiles.each do |datafile|
  txt  = File.open( datafile, 'r:utf-8') {|f| f.read }
    ## note: calculate name (cut-off pack.path!!!), that is, make path relative (to pack)
    ##   e.g.
    ##    ../../../openfootball/austria/2011-12/1-bundesliga-i.txt
    ##      becomes =>                  2011-12/1-bundesliga-i.txt
  path = datafile[ package_dir.length+1..-1 ]
  buf << "#{path}:\n"

  lineno = 0
  last_lineno = nil
  txt.each_line do |line|
     lineno += 1
     line = line.rstrip  # remove trailing newline and spaces

     if line =~ /^[ ]*#/ ||
        line =~ /#/      || ## check inline comments
        line =~ /@/      || ## check geo lines
        (line =~ /'[0-9]+/ || line =~ /[0-9]+'/)   ## check goal lines
       if last_lineno && last_lineno+1 != lineno  ## new section??
         buf << "   ...\n"
       end
       buf << "  "
       buf << '[%03d] ' % lineno
       buf << line
       buf << "\n"

       last_lineno = lineno
      else
        # do nothing; print nothing; continue
     end
  end
end


## start off with some empty lines
puts
puts
puts
puts buf

basename = File.basename( package_dir )
File.open( "./o/#{basename}.txt", 'w:utf-8' ) {|f| f.write( buf ) }

