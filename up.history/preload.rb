require_relative '../cache.weltfussball/lib/metal'


Webcache.config.root = '../../cache'


Worldfootball.config.sleep = 3




def preload( slug )
page = Worldfootball::Page::Schedule.from_cache( slug )

## pp page.seasons

page.seasons.each_with_index do |rec,i|
   url = Worldfootball::Metal.schedule_url( rec[:ref] )
   if Webcache.cached?( url )   ### check if page is cached
     print "   OK "
   else
     print "??    "
   end

   print " [%02d/%02d] " % [i+1, page.seasons.size]

   print "%-46s" % rec[:ref]
   print " - "
   print rec[:text]
   print "\n"

   ## download / preload in cache
   Worldfootball::Metal.schedule( rec[:ref] )    unless Webcache.cached?( url )
end
end # method preload


SLUGS = [
  'aut-bundesliga-2020-2021',
  'aut-2-liga-2020-2021',
  'aut-oefb-cup-2020-2021',

  'bel-eerste-klasse-a-2020-2021',

  'ita-serie-a-2020-2021',

  'esp-primera-division-2020-2021',

  'jpn-j1-league-2020',

  'bra-serie-a-2020',

  'tur-sueperlig-2020-2021',

  'ukr-premyer-liga-2019-2020',

  'swe-allsvenskan-2020',

  'sui-super-league-2020-2021',

  'mex-primera-division-2020-2021-apertura',

  'ned-eredivisie-2020-2021',

  'lux-nationaldivision-2020-2021',

  'chn-super-league-2020',
]


SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}] >#{slug}<"
  preload( slug )
end


puts "bye"
