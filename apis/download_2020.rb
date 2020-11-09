$LOAD_PATH.unshift( '../webget/lib')
$LOAD_PATH.unshift( '../football-sources/lib' )
require 'football/sources'


#############
## up (ongoing) 2020 or 2020/21 seasons

### note: free trier has a 10 request/minute limit
##  sleep/wait 10secs after every request (should result in ~6 requests/minute)

Webget.config.sleep  = 10   ## use delay / wait instead of sleep - why? why not?


Footballdata.schedule( league: 'eng.1', season: '2020/21' )
Footballdata.schedule( league: 'eng.2', season: '2020/21' )

# Footballdata.schedule( league: 'de.1', season: '2020/21' )
# Footballdata.schedule( league: 'es.1', season: '2020/21' )

# Footballdata.schedule( league: 'fr.1', season: '2020/21' )
# Footballdata.schedule( league: 'it.1', season: '2020/21' )

# Footballdata.schedule( league: 'nl.1', season: '2020/21' )
# Footballdata.schedule( league: 'pt.1', season: '2020/21' )

# Footballdata.schedule( league: 'br.1', season: '2020' )  ## note: season is calendar year!!

# Footballdata.schedule( league: 'cl', season: '2020/21' )


puts "bye"