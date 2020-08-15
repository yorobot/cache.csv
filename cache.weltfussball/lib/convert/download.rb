

module Worldfootball

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
    season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

    league  = find_league( league )

    pages =  league.pages( season: season )

    if pages.is_a?( Array )
      pages.each do |page|
        slug = page[:slug]

        url  = "#{BASE_URL}/alle_spiele/#{slug}/"

        copy( url, "./dl/#{slug}.html" )
      end # each page (of stage)
    else
      page = pages
      slug = page[:slug]

      url  = "#{BASE_URL}/alle_spiele/#{slug}/"

      copy( url, "./dl/#{slug}.html" )
    end
  end

end # module Worldfootball
