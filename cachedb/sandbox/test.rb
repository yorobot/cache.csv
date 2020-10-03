
require_relative '../lib/webcache'


puts Webcache.root
puts Webcache.config.root

Webcache.root = './cache'

puts Webcache.root
puts Webcache.config.root

url = 'https://raw.githubusercontent.com/openfootball/football.json/master/2019-20/en.1.clubs.json'
res = Webclient.get( url )

Webcache.record( url, res )

puts Webcache.exist?( url )
puts Webcache.cached?( url )

puts Webcache.exist?( 'http://foo.com/bar' )
puts Webcache.cached?( 'http://foo.com/bar' )