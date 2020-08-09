require 'pp'
require 'date'
require 'nokogiri'


##  <!-- [generated 2020-06-30 22:30:19] -->
##  <!-- [generated 2020-06-30 22:30:19] -->
GENERATED_RE = %r{
  <!--
    [ ]+
    \[generated
        [ ]+
      (?<date>\d+-\d+-\d+)
        [ ]+
      (?<time>\d+:\d+:\d+)
    \]
    [ ]+
    -->
}x


pages = Dir.glob( './dl/*' )

puts "#{pages.size} pages"
puts

pages.each do |page|
   basename = File.basename( page, File.extname( page ) )
   print "  #{basename}"

   html = File.open( page, 'r:utf-8' ) {|f| f.read }
   doc = Nokogiri::HTML( html )   ## note: use a fragment NOT a document



   # <title>Bundesliga 2010/2011 &raquo; Spielplan</title>
   title = doc.css( 'title' ).first
   print "  -  #{title.text}"
   print "\n"


   # <meta name="keywords"
   #  content="Bundesliga, 2010/2011, Spielplan, KSV Superfund, SC Magna Wiener Neustadt, SV Ried, FC Wacker Innsbruck, Austria Wien, Sturm Graz, SV Mattersburg, LASK Linz, Rapid Wien, RB Salzburg" />
   keywords = doc.css( 'meta[name="keywords"]' ).first
   ## or      doc.xpath( '//meta[@name="keywords"]' ).first
   ## pp keywords
   # puts "  #{keywords[:content]}"

   # keywords = doc.at( 'meta[@name="Keywords"]' )
   # pp keywords
   ## check for

   m=GENERATED_RE.match( html )
   if m
     date  = Date.strptime( m[:date], '%Y-%m-%d')
     today = Date.today

     diff_in_days = today.jd - date.jd
     puts "   #{diff_in_days}d   #{m[:date]} #{m[:time]}"
   end
   puts

end