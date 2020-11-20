$LOAD_PATH.unshift( 'C:/Sites/yorobot/sport.db.more/webget-football/lib' )
$LOAD_PATH.unshift( 'C:/Sites/yorobot/sport.db.more/football-sources/lib' )
require 'football/sources'




# Fbref.convert( league: 'jp.1', season: '2019' )
# Fbref.convert( league: 'mx.1', season: '2019/20' )

# Fbref.convert( league: 'at.1', season: '2018-19' )


# Fbref.config.convert.out_dir = './o2'

# convert all configured

Fbref::LEAGUES.each do |league, pages|
  pages.keys.each do |season|
     Fbref.convert( league: league,
                     season: season )
  end
end

