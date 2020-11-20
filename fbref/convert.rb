$LOAD_PATH.unshift( 'C:/Sites/yorobot/sport.db.more/webget-football/lib' )
require 'webget/football'



require_relative 'build'


module Fbref
  def self.convert( league:, season: )
    page = Page::Schedule.from_cache( league: league,
                                      season: season )

    puts page.title

    rows = page.matches
    recs = build( rows, league: league, season: season )
    ## pp rows

    ## reformat date / beautify e.g. Sat Aug 7 1993
    recs.each { |rec| rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }


    recs, headers = vacuum( recs )

    pp recs[0..2]

    season = Season.parse( season )
    path = "o/#{league}_#{season.to_path}.csv"
    puts "write #{path}..."
    Cache::CsvMatchWriter.write( path, recs, headers: headers )
  end
end # module Fbref


# Fbref.convert( league: 'jp.1', season: '2019' )
# Fbref.convert( league: 'mx.1', season: '2019/20' )

# Fbref.convert( league: 'at.1', season: '2018-19' )

# convert all configured

Fbref::LEAGUES.each do |league, pages|
  pages.keys.each do |season|
     Fbref.convert( league: league,
                     season: season )
  end
end

