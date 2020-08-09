require 'pp'
require 'date'
require 'nokogiri'

def squish( str )
  str = str.strip
  str = str.gsub( /[ \t\n]+/, ' ' )  ## fold whitespace to one max.
  str
end


def list_seasons( path )
  html = File.open( path, 'r:utf-8' ) {|f| f.read }
  doc = Nokogiri::HTML( html )   ## note: use a fragment NOT a document

  # <select name="saison" ...
  season = doc.css( 'select[name="saison"]').first
  options = season.css( 'option' )

  puts "  #{options.size} options:"
  options.each do |option|
    print "%-30s" % squish(option.text)
    print " -- >#{option[:value]}<"
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