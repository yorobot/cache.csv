require_relative 'lib/metal'


# pages = Dir.glob( './dl/at*' )
pages = Dir.glob( './dl/*' )

puts "#{pages.size} pages"
puts

pages.each do |path|
   basename = File.basename( path, File.extname( path ) )
   dirname  = File.dirname( path )
   print "#{basename}"
   page = Worldfootball::Page.from_file( path )


   url = page.url
   if url.start_with?( '//www.weltfussball.de/alle_spiele/' )
      url = url.sub( '//www.weltfussball.de/alle_spiele/', '' )
      url = url.sub( '/', '' ) ## remove trailing slash too
  else
    puts "!! ERROR - expected url in format /alle_spiele/:"
    pp page.url
    exit 1
   end

   print " => #{url} (in #{dirname})"

   print "  -  #{page.title}"
   print "\n"

   puts "  #{path} => #{dirname}/#{url}.html"
   File.rename( path, "#{dirname}/#{url}.html" )
end



puts "bye"