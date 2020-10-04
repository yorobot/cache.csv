
require_relative '../lib/webcache'


puts Webcache.home   ## built-in helper for checking home directory

puts Webcache.root
puts Webcache.config.root

# Webcache.root = './cache'
#
# puts Webcache.root
# puts Webcache.config.root



url = 'https://raw.githubusercontent.com/openfootball/football.json/master/2015-16/en.1.clubs.json'
res = Webclient.get( url )
puts res.status.code       #=> 200
puts res.status.message    #=> OK
puts res.status.ok?

puts
puts "text:"
puts res.text
puts
puts "json:"
puts res.json


Webcache.record( url, res )

puts Webcache.exist?( url )
puts Webcache.cached?( url )

puts Webcache.exist?( 'http://foo.com/bar' )
puts Webcache.cached?( 'http://foo.com/bar' )