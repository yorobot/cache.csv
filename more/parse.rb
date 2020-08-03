

def squish( str )
  str = str.strip
  str = str.gsub( /[ \t\n]+/, ' ' )  ## fold whitespace to one max.
  str
end


def parse( html )

   doc = Nokogiri::HTML.fragment( html )   ## note: use a fragment NOT a document

# <div class="data">
# <table class="standard_tabelle" cellpadding="3" cellspacing="1">

table = doc.css( 'div.data table.standard_tabelle' ).first    ## get table
# puts table.class.name  #=> Nokogiri::XML::Element
# puts table.text

trs   = table.css( 'tr' )
# puts trs.size
i = 0

last_date_str = nil
last_round    = nil

rows = []

trs.each do |tr|
  i += 1

  if tr.text.strip =~ /Spieltag/ ||
     tr.text.strip =~ /[1-9]\.[ ]Runde|
                          Achtelfinale|
                          Viertelfinale|
                          Halbfinale|
                          Finale
                          /x
    puts
    print '[%03d] ' % (i+1)
    print tr.text.strip
    print "\n"

    last_round = tr.text.strip
  else   ## assume table row (tr) is match line
    tds = tr.css( 'td' )

    date_str  = squish( tds[0].text )
    time_str  = squish( tds[1].text )
    team1_str = squish( tds[2].text )
    ## skip vs (-)
    team2_str = squish( tds[4].text )
    score_str = squish( tds[5].text )

    ## change  2:1 (1:1)  to 2-1 (1-1)
    score_str = score_str.gsub( ':', '-' )


    date_str = last_date_str    if date_str.empty?

    ## convert date from 25.10.2019 to 2019-25-10
    date     = Date.strptime( date_str, '%d.%m.%Y' )

    print '[%03d]    ' % (i+1)
    print "%-10s | " % date_str
    print "%-5s | " % time_str
    print "%-22s | " % team1_str
    print "%-22s | " % team2_str
    print score_str
    print "\n"

    rows << { round: last_round,
              date:  date.strftime( '%Y-%m-%d' ),
              time:  time_str,
              team1: team1_str,
              score: score_str,
              team2: team2_str
            }

    last_date_str = date_str
  end
end # each tr (table row)

  rows
end



if __FILE__ == $0

require 'pp'
require 'date'
require 'nokogiri'

path = './dl/weltfussball-sco.1-2018-2019-championship.html'
# path = './dl/weltfussball-de.cup-2012-2013.html'

html =  File.open( path, 'r:utf-8' ) { |f| f.read }

rows = parse( html )
## pp rows

end