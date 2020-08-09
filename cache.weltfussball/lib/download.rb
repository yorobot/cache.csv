require 'fetcher'

$LOAD_PATH.unshift( File.expand_path( '../../../../sportdb/sport.db/sportdb-formats/lib') )
require 'sportdb/formats'


require_relative '../config'



module Worldfootball

  BASE_URL = 'https://www.weltfussball.de/alle_spiele/'

  def self.worker
    @worker ||= Fetcher::Worker.new
  end

##
## note/fix!!!!
##   do NOT allow redirects for now - report error!!!
##   does NOT return 404 page not found errors; always redirects (301) to home page
##    on missing pages:
##      301 Moved Permanently location=https://www.weltfussball.de/
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



  def self.schedule( league:, season: )
    season = Season.new( season )  if season.is_a?( String )

    league  = find_league( league )

    stages =  league.stages( season: season )

    if stages
      stages.each do |stage|
        # append stage to league for lookup e.g. sco.1.regular
        slug = stage.slug( season: season )

        url  = "#{BASE_URL}#{slug}/"

        basename = "#{league.key}-#{season.to_path}-#{stage.key}"  # e.g. sco.1-2020-21-regular

        copy( url, "./dl/#{basename}.html" )
      end # each stage
    else
      slug = league.slug( season: season )

      url = "#{BASE_URL}#{slug}/"

      basename = "#{league.key}-#{season.to_path}"

      copy( url, "./dl/#{basename}.html" )
    end
  end


  def self.copy( url, path )  ## copy (save) to file
    sleep( 2 )   ## slow down - sleep 2secs before each http request

    response = worker.get( url )

    if response.code == '200'
      html = response.body.to_s
      html = html.force_encoding( Encoding::UTF_8 )

      File.open( path, 'w:utf-8' ) {|f| f.write( html ) }
    else
      puts "!! ERROR - #{response.code}:"
      pp response
      exit 1
    end
  end

end # module Worldfootball
