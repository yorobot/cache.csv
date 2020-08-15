require_relative 'lib/metal'


pages = Dir.glob( './dl/*' )

puts "#{pages.size} pages"
puts

pages.each do |path|
   basename = File.basename( path, File.extname( path ) )
   print "#{basename}"

   page = Worldfootball::Page.from_file( path )

   print "  -  #{page.title}"
   print "\n"

   puts "  #{page.generated_in_days_ago}  #{page.generated}"
end


puts "bye"