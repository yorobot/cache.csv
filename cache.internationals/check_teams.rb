require 'sportdb/config'


## use NATIONAL_TEAMS instead of COUNTRIES - why? why not?

COUNTRIES = SportDb::Import.catalog.countries


txt = File.open( './teams.txt', 'r:utf-8') {|f| f.read }

txt.each_line do |line|
  line = line.strip
  next if line.start_with?( '#' ) || line.empty?   ## skip blank and comment lines

  line = line.sub( /^[ ]*[0-9]+/, '' ).strip  ## remove leading counter

  country = COUNTRIES.find( line )
  if country
    puts "    %-32s => %s" % [line, "#{country.name} (#{country.key})"]
  else
    puts "!!  #{line}"
  end
end