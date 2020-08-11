module Worldfootball

LEAGUES_EUROPE = {

  'de.1'   => { slug: 'bundesliga' },
  'de.2'   => { slug: '2-bundesliga' },
  'de.3'   => { slug: '3-liga' },
  'de.cup' => { slug: 'dfb-pokal' },

  'at.1'   => { slug: 'aut-bundesliga' },
  'at.2'   => { slug: ->(season) {
                          season.start_year >= 2019 ? 'aut-2-liga' : 'aut-erste-liga' } },
  'at.cup' => { slug: 'aut-oefb-cup' },

  'ch.1'   => { slug: 'sui-super-league' },
  'ch.2'   => { slug: 'sui-challenge-league' },

  'eng.3'  => { slug: 'eng-league-one' },
  'eng.4'  => { slug: 'eng-league-two' },
  'eng.5'  => { slug: 'eng-national-league' },
  'eng.cup'   => { slug: 'eng-fa-cup' },    ## change key to eng.cup.fa or such??
  'eng.cup.l' => { slug: 'eng-league-cup' }, ## change key to ??

  'fr.1'  => { slug: 'fra-ligue-1' },
  'fr.2'  => { slug: 'fra-ligue-2' },

  'it.2'  => { slug: 'ita-serie-b' },

  'es.2'  => { slug: 'esp-segunda-division' },

  'ru.1'  => { slug: 'rus-premier-liga' },
  'ru.2'  => { slug: 'rus-1-division' },

  'tr.1'  => { slug: 'tur-sueperlig' },
  'tr.2'  => { slug: 'tur-1-lig' },

  # e.g. /swe-allsvenskan-2020/
  #      /swe-superettan-2020/
  'se.1'  => { slug: 'swe-allsvenskan' },
  'se.2'  => { slug: 'swe-superettan' },

  # e.g. /nor-eliteserien-2020/
  'no.1'  => { slug: 'nor-eliteserien' },

  # e.g. /isl-urvalsdeild-2020/
  'is.1'  => { slug: 'isl-urvalsdeild' },

  # e.g. /irl-premier-division-2019/
  'ie.1'  => { slug: 'irl-premier-division' },

  # e.g. /lux-nationaldivision-2020-2021/
  'lu.1' => { slug: 'lux-nationaldivision' },

  # e.g. /ned-eredivisie-2020-2021/
  'nl.1' => { slug: 'ned-eredivisie' },

  # e.g. /cro-1-hnl-2020-2021/
  'hr.1' => { slug: 'cro-1-hnl' },

  # /pol-ekstraklasa-2020-2021/
  # /pol-ekstraklasa-2019-2020-playoffs/
  # /pol-ekstraklasa-2019-2020-abstieg/
  #
  # championship round (top eight teams) and
  # relegation round (bottom eight teams)
  'pl.1' => {
     stages: {
      'regular'       => { name: 'Regular Season',          slug: 'pol-ekstraklasa-{season}' },
      'championship'  => { name: 'Playoffs - Championship', slug: 'pol-ekstraklasa-{season}-playoffs' },
      'relegation'    => { name: 'Playoffs - Relegation',   slug: 'pol-ekstraklasa-{season}-abstieg' },
     },
     format: ->( season ) {
      case season
      when Season.new('2020/21')
        %w[regular]     # just getting started
      when Season.new('2019/20')
        %w[regular championship relegation]
      when Season.new('2018/19')
        %w[regular championship relegation]
      else
        puts "!! ERROR - no configuration found for season >#{season}< for PL1 found; sorry"
        exit 1
      end
     }
    },


  # /svk-super-liga-2020-2021/
  # /svk-super-liga-2019-2020-meisterschaft/
  # /svk-super-liga-2019-2020-abstieg/
  # /svk-super-liga-2019-2020-europa-league/
  'sk.1' => {
    stages: {
    'regular'       => { name: 'Regular Season',          slug: 'svk-super-liga-{season}' },
    'championship'  => { name: 'Playoffs - Championship', slug: 'svk-super-liga-{season}-meisterschaft' },
    'relegation'    => { name: 'Playoffs - Relegation',   slug: 'svk-super-liga-{season}-abstieg' },
    'europa_finals' => { name: 'Europa League Finals',    slug: 'svk-super-liga-{season}-europa-league' },
   },
   format: ->( season ) {
    case season
    when Season.new('2020/21')
      %w[regular]  # getting started
    when Season.new('2019/20')
      %w[regular championship relegation europa_finals]
    when Season.new('2018/19')
      %w[regular championship relegation]  # note: no europa league finals / playoffs
    else
      puts "!! ERROR - no configuration found for season >#{season}< for SK1 found; sorry"
      exit 1
    end
   }
  },

  # /ukr-premyer-liga-2019-2020/
  # /ukr-premyer-liga-2019-2020-meisterschaft/
  # /ukr-premyer-liga-2019-2020-abstieg/
  # /ukr-premyer-liga-2019-2020-playoffs-el/
  'ua.1'  => {
    stages: {
    'regular'       => { name: 'Regular Season',          slug: 'ukr-premyer-liga-{season}' },
    'championship'  => { name: 'Playoffs - Championship', slug: 'ukr-premyer-liga-{season}-meisterschaft' },
    'relegation'    => { name: 'Playoffs - Relegation',   slug: 'ukr-premyer-liga-{season}-abstieg' },
    'europa_finals' => { name: 'Europa League Finals',    slug: 'ukr-premyer-liga-{season}-playoffs-el' },
   },
   format: ->( season ) {
    case season
    when Season.new('2019/20')
      %w[regular championship relegation europa_finals]
    when Season.new('2018/19')
      %w[regular championship relegation]  # note: no europa league finals / playoffs
    else
      puts "!! ERROR - no configuration found for season >#{season}< for UA1 found; sorry"
      exit 1
    end
   }
  },

  # /den-superliga-2020-2021/
  # /den-superliga-2019-2020-meisterschaft/
  # /den-superliga-2019-2020-abstieg/
  # /den-superliga-2019-2020-europa-league/
  'dk.1'  => {
    stages: {
    'regular'       => { name: 'Regular Season',          slug: 'den-superliga-{season}' },
    'championship'  => { name: 'Playoffs - Championship', slug: 'den-superliga-{season}-meisterschaft' },
    'relegation'    => { name: 'Playoffs - Relegation',   slug: 'den-superliga-{season}-abstieg' },
    'europa_finals' => { name: 'Europa League Finals',    slug: 'den-superliga-{season}-europa-league' },
   },
   format: ->( season ) {
    case season
    when Season.new('2020/21')
      %w[regular]     # just getting started
    when Season.new('2019/20')
      %w[regular championship relegation europa_finals]
    when Season.new('2018/19')
      %w[regular championship relegation europa_finals]
    else
      puts "!! ERROR - no configuration found for season >#{season}< for DK1 found; sorry"
      exit 1
    end
   }
  },

  'sco.1' => {
    stages: {
     'regular'      => { name: 'Regular Season',          slug: 'sco-premiership-{season}' },
     'championship' => { name: 'Playoffs - Championship', slug: 'sco-premiership-{end_year}-playoff' },  # note: only uses season.end_year!
     'relegation'   => { name: 'Playoffs - Relegation',   slug: 'sco-premiership-{end_year}-abstieg' },  # note: only uses season.end_year!
   },
   format: ->( season ) {
    case season
    when Season.new('2020/21')
      %w[regular]     # just getting started
    when Season.new('2019/20')
      %w[regular]     # covid-19 - no championship & relegation
    when Season.new('2018/19')
      %w[regular championship relegation]
    else
      puts "!! ERROR - no configuration found for season >#{season}< for SCO1 found; sorry"
      exit 1
    end
   }
  },


  # e.g. /fin-veikkausliiga-2019/
  #      /fin-veikkausliiga-2019-meisterschaft/
  #      /fin-veikkausliiga-2019-abstieg/
  #      /fin-veikkausliiga-2019-playoff-el/
  'fi.1' => {
    stages: {
     'regular'       => { name: 'Regular Season',          slug: 'fin-veikkausliiga-{season}' },
     'championship'  => { name: 'Playoffs - Championship', slug: 'fin-veikkausliiga-{season}-meisterschaft' },
     'challenger'    => { name: 'Playoffs - Challenger',   slug: 'fin-veikkausliiga-{season}-abstieg' },
     'europa_finals' => { name: 'Europa League Finals',    slug: 'fin-veikkausliiga-{season}-playoff-el' },
    },
    format: ->( season ) {
     case season
     when Season.new('2020')
       %w[regular]     # just getting started
     when Season.new('2019')
       %w[regular championship challenger europa_finals]
     else
       puts "!! ERROR - no configuration found for season >#{season}< for FI1 found; sorry"
       exit 1
     end
    }
  },


  # Championship play-offs
  # Europa League play-offs (Group A + Group B / Finals )

  # e.g. /bel-eerste-klasse-a-2020-2021/
  #      /bel-europa-league-playoffs-2018-2019-playoff/
  #       - Halbfinale
  #       - Finale
  'be.1' => {
    stages: {
     'regular'       => { name: 'Regular Season',                    slug: 'bel-eerste-klasse-a-{season}' },
     'championship'  => { name: 'Playoffs - Championship',           slug: 'bel-eerste-klasse-a-{season}-playoff-i' },
     'europa'        => { name: 'Playoffs - Europa League',          slug: 'bel-europa-league-playoffs-{season}' },  ## note: missing groups (A & B)
     'europa_finals' => { name: 'Playoffs - Europa League - Finals', slug: 'bel-europa-league-playoffs-{season}-playoff' },
    },
    format: ->( season ) {
      case season
      when Season.new('2020/21')
        %w[regular]     # just getting started
      when Season.new('2019/20')
        %w[regular]     # covid-19 - no championship & europa
      when Season.new('2018/19')
        %w[regular championship europa europa_finals]
      else
        puts "!! ERROR - no configuration found for season >#{season}< for BE1 found; sorry"
        exit 1
      end
    }
  },
}

end # module Worldfootball

