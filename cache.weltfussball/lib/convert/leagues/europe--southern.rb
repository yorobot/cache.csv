
module Worldfootball

LEAGUES_EUROPE.merge!({

  # /ita-serie-a-2019-2020/
  # /ita-serie-b-2020-2021/
  'it.1' =>  { pages: 'ita-serie-a' },
  'it.2' =>  { pages: 'ita-serie-b' },

  # /por-primeira-liga-2019-2020/
  # por-primeira-liga-2020-2021
  # por-primeira-liga-2019-2020
  # por-primeira-liga-2018-2019
  # por-primeira-liga-2017-2018
  # por-primeira-liga-2016-2017
  # por-primeira-liga-2015-2016
  # por-primeira-liga-2014-2015
  # por-primeira-liga-2013-2014
  # por-liga-zon-sagres-2012-2013
  # por-liga-zon-sagres-2011-2012
  # por-liga-sagres-2010-2011
  # ...
  # /por-segunda-liga-2019-2020/
  'pt.1' =>  {
    pages: ['por-primeira-liga',
            'por-liga-zon-sagres',
            'por-liga-sagres'
           ],
    season: ->( season ) {
            case season
            when Season('2013/14')..Season('2020/21') then 1
            when Season('2011/12')..Season('2012/13') then 2
            when Season('2010/11')                    then 3
            end
    },
   },
  'pt.2' =>  { pages: 'por-segunda-liga' },

  # /esp-primera-division-2019-2020/
  'es.1'  => { pages: 'esp-primera-division' },
  'es.2'  => { pages: 'esp-segunda-division' },

  # /tur-sueperlig-2020-2021/
  'tr.1'  => { pages: 'tur-sueperlig' },
  'tr.2'  => { pages: 'tur-1-lig' },

  # /gre-super-league-2020-2021/
  'gr.1'  => { pages: 'gre-super-league' },


  ## todo/check: add europe southeastern or balkans - why? why not?
  # e.g. /cro-1-hnl-2020-2021/
  'hr.1' => { pages: 'cro-1-hnl' },

})

end