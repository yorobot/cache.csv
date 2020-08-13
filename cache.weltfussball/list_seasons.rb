require_relative  'lib/metal'


def list_seasons( path )
  page = Worldfootball::Page::Schedule.from_file( path )

  seasons = page.seasons
  puts "  #{seasons.size} seasons - in >#{page.title}< page"
  seasons.each do |season|
    print "%-30s" % season[:text]
    print " -- >#{season[:ref]}<"
    print "\n"
  end
end


list_seasons( "./dl/at.1-2010-11.html" )
puts
list_seasons( "./dl/mx.1-2018-19-apertura.html" )
puts
list_seasons( "./dl/be.1-2018-19-championship.html" )
puts
list_seasons( "./dl/be.1-2018-19-europa.html" )
puts
list_seasons( "./dl/kr.1-2020-regular.html" )
puts