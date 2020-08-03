require 'fetcher'

$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib') )
require 'sportdb/formats'


require_relative './config'



module Worldfootball

  BASE_URL = 'https://www.weltfussball.de/alle_spiele/'

  def self.worker
    @worker ||= Fetcher::Worker.new
  end

##
## note:
##   does NOT return 404 page not found errors; always redirects (301) to home page
##    on missing pages:
##      301 Moved Permanently location=https://www.weltfussball.de/

## note: use aut-2-liga !!! starting 2019-2018 !!!
##       use aut-erste-liga !!! before e.g. 2010-2011 etc.
# url = "https://www.weltfussball.de/alle_spiele/aut-erste-liga-#{season}/"
# url = "https://www.weltfussball.de/alle_spiele/2-bundesliga-#{season}/"
# url = "https://www.weltfussball.de/alle_spiele/eng-league-one-#{season}/"
# url = "https://www.weltfussball.de/alle_spiele/eng-league-two-#{season}/"
# url = 'https://www.weltfussball.de/alle_spiele/aut-bundesliga-2010-2011/'
#        https://www.weltfussball.de/alle_spiele/aut-erste-liga-2010-2011/
#        https://www.weltfussball.de/alle_spiele/2-bundesliga-2013-2014/
#        https://www.weltfussball.de/alle_spiele/fra-ligue-2-2019-2020/
#        https://www.weltfussball.de/alle_spiele/ita-serie-b-2019-2020/
#        https://www.weltfussball.de/alle_spiele/rus-premier-liga-2019-2020/
#        https://www.weltfussball.de/alle_spiele/rus-1-division-2019-2020/
#        https://www.weltfussball.de/alle_spiele/sui-super-league-2019-2020/
#        https://www.weltfussball.de/alle_spiele/sui-challenge-league-2019-2020/
#        https://www.weltfussball.de/alle_spiele/tur-sueperlig-2019-2020/
#        https://www.weltfussball.de/alle_spiele/tur-1-lig-2019-2020/
#        https://www.weltfussball.de/alle_spiele/aut-oefb-cup-2019-2020/
#        https://www.weltfussball.de/alle_spiele/dfb-pokal-2019-2020/
#        https://www.weltfussball.de/alle_spiele/eng-national-league-2019-2020/
#        https://www.weltfussball.de/alle_spiele/eng-fa-cup-2018-2019/
#        https://www.weltfussball.de/alle_spiele/eng-league-cup-2019-2020/

## e.g. 2010-2011,
##      2011-2012,
##      2012-2013, 2013-2014, 2014-2015, 2015-2016, 2016-2017, 2017-2018


  def self.league_slug( league:, season: )
    val = LEAGUES[ league ]

    val = val.call( season )   if val.is_a?( Proc )

    if val.nil?
      puts "!! ERROR - no league found for >#{league}<; add to leagues tables"
      exit 1
    end

    ## note: fill-in/check for place holders too
    val = if val.index( '{season}' )
             val.sub( '{season}', season.to_path( :long ) )  ## e.g. 2010-2011
          elsif val.index( '{end_year}' )
             val.sub( '{end_year}', season.end_year.to_s )   ## e.g. 2011
          else
             ## assume convenience fallback - append regular season
             val + "-#{season.to_path( :long )}"
          end

    puts "  slug=>#{val}<"

    val
  end



  def self.schedule_with_stages( league:, season: )
    season = Season.new( season )  if season.is_a?( String )

    ## stages = sco1( season )
    stages = be1( season )

    stages.each do |stage|
      sleep( 1 )   ## slow down - sleep 1sec before each http request

      league_stage = "#{league}.#{stage}"   # e.g. sco.1.regular
      slug = league_slug( league: league_stage, season: season )

      url = "#{BASE_URL}#{slug}/"

      response = worker.get( url )

      if response.code == '200'
        html = response.body.to_s
        html = html.force_encoding( Encoding::UTF_8 )

        basename = "#{league}-#{season.to_path(:long)}-#{stage}"  # e.g. sco.1-2020-2021-regular
        File.open( "./dl/weltfussball-#{basename}.html", 'w:utf-8' ) {|f| f.write( html ) }
      else
        puts "!! ERROR - #{response.code}:"
        pp response
        exit 1
      end
    end # each stage
  end


  ## fetch and save (single/all-in-one page) match schedule
  def self.schedule( league:, season: )
    season = Season.new( season )  if season.is_a?( String )

    slug = league_slug( league: league, season: season )

    season_path = season.to_path( :long )  # e.g. 2010-2011  etc.
    url = "#{BASE_URL}#{slug}-#{season_path}/"

    response = worker.get( url )

    if response.code == '200'
      html = response.body.to_s
      html = html.force_encoding( Encoding::UTF_8 )

      File.open( "./dl/weltfussball-#{league}-#{season_path}.html", 'w:utf-8' ) {|f| f.write( html ) }
    else
      puts "!! ERROR - #{response.code}:"
      pp response
      exit 1
    end
  end
end


# Worldfootball.schedule_with_stages( league: 'sco.1', season: '2020/21' )
# Worldfootball.schedule_with_stages( league: 'sco.1', season: '2019/20' )
# Worldfootball.schedule_with_stages( league: 'sco.1', season: '2018/19' )

Worldfootball.schedule_with_stages( league: 'be.1', season: '2020/21' )
Worldfootball.schedule_with_stages( league: 'be.1', season: '2019/20' )
Worldfootball.schedule_with_stages( league: 'be.1', season: '2018/19' )


# Worldfootball.schedule( league: 'eng.4', season: '2017/18' )
# Worldfootball.schedule( league: 'eng.5', season: '2018/19' )
# Worldfootball.schedule( league: 'eng.5', season: '2019/20' )

# Worldfootball.schedule( league: 'eng.cup', season: '2018/19' )
# Worldfootball.schedule( league: 'eng.cup', season: '2019/20' )

# Worldfootball.schedule( league: 'eng.cup.l', season: '2019/20' )

# Worldfootball.schedule( league: 'fr.1', season: '2020/21' )
# Worldfootball.schedule( league: 'fr.2', season: '2020/21' )


# Worldfootball.schedule( league: 'fr.2', season: '2019/20' )
# Worldfootball.schedule( league: 'fr.2', season: '2015/16' )
# Worldfootball.schedule( league: 'fr.2', season: '2016/17' )
# Worldfootball.schedule( league: 'fr.2', season: '2017/18' )
# Worldfootball.schedule( league: 'fr.2', season: '2018/19' )


# Worldfootball.schedule( league: 'es.2', season: '2012/13' )
# Worldfootball.schedule( league: 'es.2', season: '2013/14' )
# Worldfootball.schedule( league: 'es.2', season: '2014/15' )
# Worldfootball.schedule( league: 'es.2', season: '2015/16' )
# Worldfootball.schedule( league: 'es.2', season: '2016/17' )
# Worldfootball.schedule( league: 'es.2', season: '2017/18' )
# Worldfootball.schedule( league: 'es.2', season: '2018/19' )
# Worldfootball.schedule( league: 'es.2', season: '2019/20' )



# Worldfootball.schedule( league: 'it.2', season: '2019/20' )
# Worldfootball.schedule( league: 'it.2', season: '2013/14' )
# Worldfootball.schedule( league: 'it.2', season: '2014/15' )
# Worldfootball.schedule( league: 'it.2', season: '2015/16' )
# Worldfootball.schedule( league: 'it.2', season: '2016/17' )
# Worldfootball.schedule( league: 'it.2', season: '2017/18' )
# Worldfootball.schedule( league: 'it.2', season: '2018/19' )


# Worldfootball.schedule( league: 'ru.1', season: '2019/20' )
# Worldfootball.schedule( league: 'ru.2', season: '2019/20' )

# Worldfootball.schedule( league: 'ch.1', season: '2019/20' )
# Worldfootball.schedule( league: 'ch.2', season: '2019/20' )

# Worldfootball.schedule( league: 'tr.1', season: '2019/20' )
# Worldfootball.schedule( league: 'tr.2', season: '2019/20' )


# Worldfootball.schedule( league: 'at.cup', season: '2019/20' )
# sleep(1)
# Worldfootball.schedule( league: 'at.cup', season: '2018/19' )
# Worldfootball.schedule( league: 'at.cup', season: '2011/12' )
# Worldfootball.schedule( league: 'at.cup', season: '2012/13' )
# Worldfootball.schedule( league: 'at.cup', season: '2013/14' )
# Worldfootball.schedule( league: 'at.cup', season: '2014/15' )
# Worldfootball.schedule( league: 'at.cup', season: '2015/16' )
# Worldfootball.schedule( league: 'at.cup', season: '2016/17' )
# Worldfootball.schedule( league: 'at.cup', season: '2017/18' )

# Worldfootball.schedule( league: 'at.2', season: '2014/15' )
# sleep(1)
# Worldfootball.schedule( league: 'at.2', season: '2015/16' )

# Worldfootball.schedule( league: 'at.2', season: '2016/17' )
# sleep(1)
# Worldfootball.schedule( league: 'at.2', season: '2017/18' )

# Worldfootball.schedule( league: 'de.cup', season: '2019/20' )
# sleep(1)
# Worldfootball.schedule( league: 'de.cup', season: '2018/19' )

# Worldfootball.schedule( league: 'de.cup', season: '2012/13' )
# Worldfootball.schedule( league: 'de.cup', season: '2013/14' )
# Worldfootball.schedule( league: 'de.cup', season: '2014/15' )
# Worldfootball.schedule( league: 'de.cup', season: '2015/16' )
# Worldfootball.schedule( league: 'de.cup', season: '2016/17' )
# Worldfootball.schedule( league: 'de.cup', season: '2017/18' )
