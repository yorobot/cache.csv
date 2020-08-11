require_relative 'lib/page'



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


leagues = {}


pages = Dir.glob( './dl/*' )

puts "#{pages.size} pages"
puts

pages.each do |path|
   basename = File.basename( path, File.extname( path ) )
   print "#{basename}"

   page = Worldfootball::Page.from_file( path )

   print "  -  #{page.title}"
   print "\n"

   ## puts "    #{page.keywords}"

   date   = page.generated
   today = Date.today

   diff_in_days = today.jd - date.jd
   puts "  #{diff_in_days}d   #{date}"


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



## print stats
puts
puts
puts "#{leagues.size} leagues:"
leagues.each do |key,seasons_hash|
  puts "  #{key} - #{seasons_hash.size} seasons (#{seasons_hash.keys.join(' ')}):"
end



puts "bye"