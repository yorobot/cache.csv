$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
$LOAD_PATH.unshift( '../../sport.db.more/webget-football/lib' )
$LOAD_PATH.unshift( '../../sport.db.more/football-sources/lib' )

require 'football/sources'



#########
# download latest
Webcache.root = '../../../cache'  ### c:\sports\cache

Webget.config.sleep  = 11    ## max. 10 requests/minute

# Footballdata.schedule( league: 'eng.1', season: '2023/24' )
# Footballdata.schedule( league: 'de.1',  season: '2023/24' )

# note:  it.1 2023/2024 ends jul/2 !!!
# Footballdata.schedule( league: 'it.1',  season: '2023/24' )
# Footballdata.schedule( league: 'fr.1',  season: '2023/24' )


#####
# convert for staging
Footballdata.config.convert.out_dir = '../../../stage'


## use LATEST_SEASONS or such - why? why not?
SEASONS = %w[2023/24 2022/23 2021/22 2020/21]

DATASETS = [
 ['eng.1',   SEASONS],  
 ['de.1',    SEASONS],
 ['it.1',    SEASONS - %w[2023/24]],
 ['fr.1',    SEASONS] 
]


DATASETS.each do |league, seasons|
  seasons.each_with_index do |season,i|
    puts "==> #{league} #{season} - #{i+1}/#{seasons.size}..."
    Footballdata.convert( league: league, season: season )
  end 
end



puts "bye"


__END__
!! check for 2020/21 in it.1
  1,Sat Sep 19 2020,Hellas Verona FC,3-0 (*),,AS Roma,awarded

  

!! ERROR - no club match found for >AC Monza<
1 error(s) - teams:
["AC Monza > Italy"]


!! ERROR: unsupported match status >IN_PLAY< - sorry:
"utcDate"=>"2024-05-20T16:30:00Z",
"status"=>"IN_PLAY",
"matchday"=>37,

note - IN_PLAY (same as playing now!!! LIVE)
##  retry when match ended!!!!


