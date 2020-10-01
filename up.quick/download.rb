require_relative '../cache.weltfussball/lib/convert'



Worldfootball.config.sleep = 3

Worldfootball.config.cache.schedules_dir = '../cache.weltfussball/dl'
Worldfootball.config.cache.reports_dir   = '../cache.weltfussball/dl2'

SLUGS = %w[
  eng-premier-league-1998-1999
]


SLUGS.each_with_index do |slug,i|
  puts "[#{i+1}/#{SLUGS.size}]>#{slug}<"
  Worldfootball::Metal.schedule( slug )
end


puts "bye"
