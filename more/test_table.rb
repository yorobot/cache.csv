require 'pp'
require 'nokogiri'

require_relative '../csv'


# path = './dl/weltfussball-at1-2010-2011.html'

season = '2013-2014'
basename = 'de.2'
path = "./dl/weltfussball-#{basename}-#{season}.html"
html =  File.open( path, 'r:utf-8' ) { |f| f.read }



MODS = {
  ## AT 1
  'SC Magna Wiener Neustadt' => 'SC Wiener Neustadt', # in 2010/11
  'KSV Superfund'            => 'Kapfenberger SV',    # in 2010/11
  'Kapfenberger SV 1919'     => 'Kapfenberger SV',    # in 2011/12
  'FC Trenkwalder Admira'    => 'FC Admira Wacker',    # in 2011/12
  ## AT 2
  'Austria Wien (A)'         => 'Young Violets',  # in 2019/20
  'FC Wacker Innsbruck (A)'  => 'FC Wacker Innsbruck II',   # in 2018/19
}


doc = Nokogiri::HTML.fragment( html )   ## note: use a fragment NOT a document


def squish( str )
  str = str.strip
  str = str.gsub( /[ \t\n]+/, ' ' )  ## fold whitespace to one max.
  str
end


# <div class="data">
# <table class="standard_tabelle" cellpadding="3" cellspacing="1">

table = doc.css( 'div.data table.standard_tabelle' ).first    ## get table
puts table.class.name
# puts table.text

trs   = table.css( 'tr' )
# puts trs.size
i = 0

last_date_str = nil
last_round    = nil

recs = []

trs.each do |tr|
  i += 1

  if tr.text.strip =~ /Spieltag/
    puts
    print '[%03d] ' % (i+1)
    print tr.text.strip

    if m = tr.text.strip.match( /([0-9]+)\. Spieltag/ )
      last_round = m[1].to_i
      print " => #{last_round}"
    else
      puts "!! ERROR: cannot find matchday number"
      exit 1
    end
    print "\n"
  else
    tds = tr.css( 'td' )

    date_str  = squish( tds[0].text )
    time_str  = squish( tds[1].text )
    team1_str = squish( tds[2].text )
    ## skip vs (-)
    team2_str = squish( tds[4].text )
    score_str = squish( tds[5].text )

    ## change  2:1 (1:1)  to 2-1 (1-1)
    score_str = score_str.gsub( ':', '-' )
    ## check for 0:3 Wert.   - change Wert. to awd.  (awarded)
    score_str = score_str.sub( /Wert\./i, 'awd.' )

    team1_str = MODS[ team1_str ]   if MODS[ team1_str ]
    team2_str = MODS[ team2_str ]   if MODS[ team2_str ]

    print '[%03d]    ' % (i+1)
    print "%-10s | " % ( date_str.empty? ? last_date_str : date_str )
    print "%-5s | " % time_str
    print "%-22s | " % team1_str
    print "%-22s | " % team2_str
    print score_str
    print "\n"

    recs << [last_round,
             date_str.empty? ? last_date_str : date_str,
             time_str,
             team1_str,
             score_str,
             team2_str
            ]

    last_date_str = date_str  if date_str.size > 0
  end
end


out_path = "./o/#{season}/#{basename}.csv"

headers = [
  'Matchday',
  'Date',
  'Time',
  'Team 1',
  'Score',
  'Team 2'
]

Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
