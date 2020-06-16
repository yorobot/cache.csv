require 'sportdb/config'



LEAGUES = SportDb::Import.catalog.leagues


txt = File.open( './tournaments.txt', 'r:utf-8') {|f| f.read }

txt.each_line do |line|
  line = line.strip
  next if line.start_with?( '#' ) || line.empty?   ## skip blank and comment lines

  line = line.sub( /^[ ]*[0-9]+/, '' ).strip  ## remove leading counter

  league = LEAGUES.find( line )
  if league
    puts "    %-32s => %s" % [line, "#{league.name} (#{league.key})"]
  else
    puts "!!  #{line}"
  end
end

