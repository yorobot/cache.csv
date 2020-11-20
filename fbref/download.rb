$LOAD_PATH.unshift( 'C:/Sites/yorobot/sport.db.more/webget-football/lib' )
require 'webget/football'


# Fbref.schedule( league: 'mx.1', season: '2019/20' )
# Fbref.schedule( league: 'jp.1', season: '2019' )

[
 # ['br.1', ['2020']],
 ['de.1', ['2020/21']],
 ['es.1', ['2020/21']],
 ['it.1', ['2020/21']],
 ['fr.1', ['2020/21']],
].each do |dataset|
  league  = dataset[0]
  seasons = dataset[1]
  seasons.each do |season|
    Fbref.schedule( league: league, season: season )
  end
end



__END__
# download all configured

Fbref::LEAGUES.each do |league, pages|
   pages.keys.each do |season|
      Fbref.schedule( league: league,
                      season: season )
   end
end
