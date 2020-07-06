require 'fetcher'

worker = Fetcher::Worker.new

# url = 'https://www.weltfussball.de/alle_spiele/aut-bundesliga-2010-2011/'
#        https://www.weltfussball.de/alle_spiele/aut-erste-liga-2010-2011/
#        https://www.weltfussball.de/alle_spiele/2-bundesliga-2013-2014/
## e.g. 2010-2011,
##      2011-2012,
##      2012-2013, 2013-2014, 2014-2015, 2015-2016, 2016-2017, 2017-2018

season = '2019-2020'
basename = 'eng.4'

## note: use aut-2-liga !!! starting 2019-2018 !!!
##       use aut-erste-liga !!! before e.g. 2010-2011 etc.
# url = "https://www.weltfussball.de/alle_spiele/aut-erste-liga-#{season}/"
# url = "https://www.weltfussball.de/alle_spiele/2-bundesliga-#{season}/"
# url = "https://www.weltfussball.de/alle_spiele/eng-league-one-#{season}/"
url = "https://www.weltfussball.de/alle_spiele/eng-league-two-#{season}/"

response = worker.get( url )

if response.code == '200'
  html = response.body.to_s
  html = html.force_encoding( Encoding::UTF_8 )

  File.open( "./dl/weltfussball-#{basename}-#{season}.html", 'w:utf-8' ) {|f| f.write( html ) }
else
  puts "!! #{response.code}:"
  pp response
end