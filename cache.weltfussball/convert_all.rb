require_relative 'lib/convert'


# OUT_DIR='./o'
# OUT_DIR='./o/fr'
# OUT_DIR='./o/at'
# OUT_DIR='./o/de'
# OUT_DIR='./o/eng'
OUT_DIR='../../stage/two'

# OUT_DIR='./o/test'
# OUT_DIR='./tmp'



BASENAME_RE = %r{^
  (?<key1>[a-z]+)
  (?<key2>
     (?:\.[a-z_0-9]+)+
  )
    -
  (?<season>\d{4} (?:-\d{2})?)
  (?:
    -
    (?<stage>[a-z_]+)
  )?
  $}x

pages = Dir.glob( './dl/*' )

puts "#{pages.size} pages"
puts


leagues = {}

pages.each do |page|
   basename = File.basename( page, File.extname( page ) )
   print "  #{basename}"
   print "\n"

   m=BASENAME_RE.match( basename )
   if m
     print "    "
     print "%-10s" % (m[:key1]+m[:key2])
     print "| %-8s" % m[:season]
     print "| %-12s" % m[:stage]   if m[:stage]
     print "\n"

     key    = m[:key1]+m[:key2]
     season = m[:season]
     stage  = m[:stage]

     seasons = leagues[key] ||= {}
     seasons[season] ||= []
     seasons[season] << stage    if stage
   else
    puts "!! ERROR: unknown filename naming format; CANNOT split basename"
    exit 1
   end
end

pp leagues



###
## convert
##  todo/fix:
##    time offset (e.g -7 for Mexico) and others missing!!!
##  add somehow!!!


leagues.each do |key,seasons_hash|
  puts "  #{key} - #{seasons_hash.size} seasons (#{seasons_hash.keys.join(' ')}):"

  ## note: skip english league cup for now; needs score format fix (no extra time but penalties)
  ##  [010] 1. Runde => Round 1
  ##  [010]    2019-08-13 | 20:45 | Blackpool FC           | Macclesfield Town      | 2-4 (1-1, 2-2) i.E.
  ##  !! ERROR - unsupported score format >2-4 (1-1, 2-2) i.E.< - sorry
  next if ['eng.cup.l'].include?( key )

  seasons_hash.each do |season, stages|
    puts "    convert( league: '#{key}', season: '#{season}' )"
    convert( league: key, season: season )
  end
end


## print stats
puts
puts
puts "#{leagues.size} leagues:"
leagues.each do |key,seasons_hash|
  puts "  #{key} - #{seasons_hash.size} seasons (#{seasons_hash.keys.join(' ')}):"
end
puts "bye"
