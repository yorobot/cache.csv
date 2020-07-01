require 'pp'
require 'nokogiri'

require 'sportdb/formats'   ## for Season -- move to test_schedule /fetch!!!!

require_relative '../csv'




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



def squish( str )
  str = str.strip
  str = str.gsub( /[ \t\n]+/, ' ' )  ## fold whitespace to one max.
  str
end


def convert( season, league )
   # season   = '2019-2020'
   # basename = 'at.2'
  basename =   league

  path = "./dl/weltfussball-#{basename}-#{season}.html"


html =  File.open( path, 'r:utf-8' ) { |f| f.read }

doc = Nokogiri::HTML.fragment( html )   ## note: use a fragment NOT a document


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

    date_str = last_date_str    if date_str.empty?

    print '[%03d]    ' % (i+1)
    print "%-10s | " % date_str
    print "%-5s | " % time_str
    print "%-22s | " % team1_str
    print "%-22s | " % team2_str
    print score_str
    print "\n"



    ## convert date from 25.10.2019 to 2019-25-10
    date = Date.strptime( date_str, '%d.%m.%Y' )

    comments = String.new( '' )

    ## split score
    ft = ''
    ht = ''
    if score_str =~ /---/
      ft = ''
      ht = ''
    elsif score_str =~ /([0-9]+)
                            [ ]*-[ ]*
                        ([0-9]+)
                            [ ]*
                        \(([0-9]+)
                            [ ]*-[ ]*
                          ([0-9]+)
                        \)
                       /x
      ft = "#{$1}-#{$2}"
      ht = "#{$3}-#{$4}"
    elsif  score_str =~ /([0-9]+)
                           [ ]*-[ ]*
                         ([0-9]+)
                           [ ]*
                          ([a-z.]+)
                         /x
      ft = "#{$1}-#{$2} (*)"
      ht = ''
      comments = $3
    else
       puts "!! ERROR - unsupported score format #{score_str} - sorry"
       exit 1
    end

    recs << [last_round,
             date.strftime( '%Y-%m-%d' ),
             time_str,
             team1_str,
             ft,
             ht,
             team2_str,
             comments]

    last_date_str = date_str
  end
end


season = SportDb::Import::Season.new( season )



##   note:  sort matches by date before saving/writing!!!!
##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
## note: assume date is first column!!!
recs = recs.sort { |l,r| l[1] <=> r[1] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each { |rec| rec[1] = Date.strptime( rec[1], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }


out_path = "./o/#{season.path}/#{basename}.csv"

puts "write #{out_path}..."


headers = [
  'Matchday',
  'Date',
  'Time',
  'Team 1',
  'FT',
  'HT',
  'Team 2',
  'Comments'    ## e.g. awarded
]

Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end


# path = './dl/weltfussball-at1-2010-2011.html'

# season = '2013-2014'
# basename = 'de.2'

LEAGUES = [['at.1', ['2010-2011', '2011-2012', '2012-2013', '2013-2014','2014-2015',
                     '2015-2016', '2016-2017', '2017-2018']],
           ['at.2', ['2010-2011', '2011-2012',
                     '2018-2019', '2019-2020']],
           ['de.2', ['2013-2014']],
          ]

pp LEAGUES


LEAGUES.each do |league|
  basename = league[0]
  league[1].each do |season|
    convert( season, basename )
  end
end
