
module Worldfootball

LEAGUES_EUROPE.merge!({

  'ru.1'  => { pages: 'rus-premier-liga' },
  'ru.2'  => { pages: 'rus-1-division' },

  # /ukr-premyer-liga-2019-2020/
  # /ukr-premyer-liga-2019-2020-meisterschaft/
  # /ukr-premyer-liga-2019-2020-abstieg/
  # /ukr-premyer-liga-2019-2020-playoffs-el/
  'ua.1'  => {
    pages: {
     'ukr-premyer-liga-{season}'               => 'Regular Season',
     'ukr-premyer-liga-{season}-meisterschaft' => 'Playoffs - Championship',
     'ukr-premyer-liga-{season}-abstieg'       => 'Playoffs - Relegation',
     'ukr-premyer-liga-{season}-playoffs-el'   => 'Europa League Finals',
   },
   season: ->( season ) {
    case season
    when Season('2019/20') then [1,2,3,4]
    when Season('2018/19') then [1,2,3]    # note: no europa league finals / playoffs
    end
   }
  },

})

end

