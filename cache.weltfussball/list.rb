require_relative 'lib/page'



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
end

