
module Worldfootball


LEAGUES_EUROPE.merge!({
  'de.1'   => { pages: 'bundesliga' },
  'de.2'   => { pages: '2-bundesliga' },
  'de.3'   => { pages: '3-liga' },
  'de.cup' => { pages: 'dfb-pokal' },


=begin
  2019/2020 Qualifikationsgruppe -- >/alle_spiele/aut-bundesliga-2019-2020-qualifikationsgruppe/<
  2019/2020 Playoff              -- >/alle_spiele/aut-bundesliga-2019-2020-playoff/<
  2019/2020 Meistergruppe        -- >/alle_spiele/aut-bundesliga-2019-2020-meistergruppe/<
  2019/2020                      -- >/alle_spiele/aut-bundesliga-2019-2020/<
  2018/2019 Qualifikationsgruppe -- >/alle_spiele/aut-bundesliga-2018-2019-qualifikationsgruppe/<
  2018/2019 Playoff              -- >/alle_spiele/aut-bundesliga-2018-2019-playoff/<
  2018/2019 Meistergruppe        -- >/alle_spiele/aut-bundesliga-2018-2019-meistergruppe/<
=end

  'at.1' => {
    pages: {
      'aut-bundesliga-{season}'                      => 'Grunddurchgang',                  # 1
      'aut-bundesliga-{season}-meistergruppe'        => 'Finaldurchgang - Meister',        # 2
      'aut-bundesliga-{season}-qualifikationsgruppe' => 'Finaldurchgang - Qualifikation',  # 3
      'aut-bundesliga-{season}-playoff'              => 'Europa League Play-off',          # 4
    },
    season: ->( season ) {
                  case season
                  when Season('2018/19')..Season('2019/20') then [1,2,3,4]
                  else  1   ## use simple format for the rest; note: index NOT wrapped in array
                  end
    },
   },
  'at.2'   => {
    pages: ['aut-2-liga',
            'aut-erste-liga'],
    season: ->(season) { season.start_year >= 2019 ? 1 : 2 }
  },
  'at.cup' => { pages: 'aut-oefb-cup' },


  'ch.1'   => { pages: 'sui-super-league' },
  'ch.2'   => { pages: 'sui-challenge-league' },

  # /pol-ekstraklasa-2020-2021/
  # /pol-ekstraklasa-2019-2020-playoffs/
  # /pol-ekstraklasa-2019-2020-abstieg/
  #
  # championship round (top eight teams) and
  # relegation round (bottom eight teams)
  'pl.1' => {
     pages: {
      'pol-ekstraklasa-{season}'          => 'Regular Season',           # 1
      'pol-ekstraklasa-{season}-playoffs' => 'Playoffs - Championship',  # 2
      'pol-ekstraklasa-{season}-abstieg'  => 'Playoffs - Relegation',    # 3
     },
     season: ->( season ) {
      case season
      when Season('2020/21') then [1]     # just getting started
      when Season('2019/20') then [1,2,3]
      when Season('2018/19') then [1,2,3]
      end
     }
    },

  # /svk-super-liga-2020-2021/
  # /svk-super-liga-2019-2020-meisterschaft/
  # /svk-super-liga-2019-2020-abstieg/
  # /svk-super-liga-2019-2020-europa-league/
  'sk.1' => {
    pages: {
      'svk-super-liga-{season}'               => 'Regular Season',           # 1
      'svk-super-liga-{season}-meisterschaft' => 'Playoffs - Championship',  # 2
      'svk-super-liga-{season}-abstieg'       => 'Playoffs - Relegation',    # 3
      'svk-super-liga-{season}-europa-league' => 'Europa League Finals',     # 4
   },
   season: ->( season ) {
    case season
    when Season('2020/21') then [1]  # getting started
    when Season('2019/20') then [1,2,3,4]
    when Season('2018/19') then [1,2,3]    # note: no europa league finals / playoffs
    end
   }
  },


})

end
