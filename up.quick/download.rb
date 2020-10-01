require_relative '../cache.weltfussball/lib/convert'


Webcache.config.root = '../../cache'


Worldfootball.config.sleep = 3



SLUGS = %w[
  eng-premier-league-1998-1999
]


SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}]>#{slug}<"
  Worldfootball::Metal.schedule( slug )
end


puts "bye"
