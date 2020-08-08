##########
#  shared "standalone" / no-dependencies configuration for (re)use


module Worldfootball

LEAGUE_FORMATS = {}

## todo/check: change to LEAGUE_SLUGS or such - why? why not?
LEAGUES = {
  'de.2'   => '2-bundesliga',
  'de.cup' => 'dfb-pokal',

  'at.1' => 'aut-bundesliga',
  'at.2' =>  ->(season) { season.start_year >= 2019 ?
                             'aut-2-liga' : 'aut-erste-liga' },
  'at.cup' => 'aut-oefb-cup',

  'ch.1' => 'sui-super-league',
  'ch.2' => 'sui-challenge-league',

  'eng.3' => 'eng-league-one',
  'eng.4' => 'eng-league-two',
  'eng.5' => 'eng-national-league',
  'eng.cup'   => 'eng-fa-cup',    ## change key to eng.cup.fa or such??
  'eng.cup.l' => 'eng-league-cup', ## change key to ??

  'fr.1'  => 'fra-ligue-1',
  'fr.2'  => 'fra-ligue-2',

  'it.2'  => 'ita-serie-b',

  'es.2'  => 'esp-segunda-division',

  'ru.1'  => 'rus-premier-liga',
  'ru.2'  => 'rus-1-division',

  'tr.1'  => 'tur-sueperlig',
  'tr.2'  => 'tur-1-lig',

  # https://www.weltfussball.de/alle_spiele/swe-allsvenskan-2020/
  # https://www.weltfussball.de/alle_spiele/swe-superettan-2020/
  'se.1'  => 'swe-allsvenskan',
  'se.2'  => 'swe-superettan',

  # https://www.weltfussball.de/alle_spiele/nor-eliteserien-2020/
  'no.1'  => 'nor-eliteserien',
}




LEAGUE_FORMATS[ 'sco.1' ] = ->( season ) {
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

LEAGUES.merge!(
  'sco.1.regular'      =>  { slug: 'sco-premiership-{season}',
                             name: 'Regular Season' },
  'sco.1.championship' =>  { slug: 'sco-premiership-{end_year}-playoff',  # note: only uses season.end_year!
                             name: 'Playoffs - Championship' },
  'sco.1.relegation'   =>  { slug: 'sco-premiership-{end_year}-abstieg',  # note: only uses season.end_year!
                             name: 'Playoffs - Relegation' },
)



LEAGUE_FORMATS[ 'fi.1' ] = -> ( season ) {
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

# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019/
# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019-meisterschaft/
# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019-abstieg/
# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019-playoff-el/

LEAGUES.merge!(
  'fi.1.regular'       => { slug: 'fin-veikkausliiga-{season}',
                            name: 'Regular Season' },
  'fi.1.championship'  => { slug: 'fin-veikkausliiga-{season}-meisterschaft',
                            name: 'Playoffs - Championship' },
  'fi.1.challenger'    => { slug: 'fin-veikkausliiga-{season}-abstieg',
                            name: 'Playoffs - Challenger' },
  'fi.1.europa_finals' => { slug: 'fin-veikkausliiga-{season}-playoff-el',
                            name: 'Europa League Finals' },
)







# Championship play-offs
# Europa League play-offs (Group A + Group B / Finals )

LEAGUE_FORMATS[ 'be.1' ] = -> ( season ) {
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

# https://www.weltfussball.de/alle_spiele/bel-eerste-klasse-a-2020-2021/
# https://www.weltfussball.de/alle_spiele/bel-europa-league-playoffs-2018-2019-playoff/
#   - Halbfinale
#   - Finale
LEAGUES.merge!(
  'be.1.regular'       => 'bel-eerste-klasse-a-{season}',
  'be.1.championship'  => 'bel-eerste-klasse-a-{season}-playoff-i',
  'be.1.europa'        => 'bel-europa-league-playoffs-{season}',  ## note: missing groups (A & B)
  'be.1.europa_finals' => 'bel-europa-league-playoffs-{season}-playoff',
)


LEAGUE_FORMATS[ 'mx.1' ] = -> ( season ) {
  case season
  when Season.new('2020/21')
    %w[apertura]     # just getting started
  when Season.new('2019/20')
    %w[apertura apertura_finals clausura]     # covid-19 - no liguilla
  when Season.new('2018/19')
    %w[apertura apertura_finals clausura clausura_finals]
  else
    puts "!! ERROR - no configuration found for season >#{season}< for MX1 found; sorry"
    exit 1
  end
}


# todo/fix: adjust date/time by -7 hours!!!
##  e.g. 25.07.2020	02:30  => 24.07.2020 19.30
#        11.01.2020	04:00  => 10.01.2020 21.00
# https://www.weltfussball.de/alle_spiele/mex-primera-division-2020-2021-apertura/
# https://www.weltfussball.de/alle_spiele/mex-primera-division-2019-2020-clausura/
# https://www.weltfussball.de/alle_spiele/mex-primera-division-2019-2020-apertura-playoffs/
#  - Viertelfinale
#  - Halbfinale
#  - Finale
# https://www.weltfussball.de/alle_spiele/mex-primera-division-2018-2019-clausura-playoffs/
LEAGUES.merge!(
  'mx.1.apertura'        => 'mex-primera-division-{season}-apertura',
  'mx.1.apertura_finals' => 'mex-primera-division-{season}-apertura-playoffs',
  'mx.1.clausura'        => 'mex-primera-division-{season}-clausura',
  'mx.1.clausura_finals' => 'mex-primera-division-{season}-clausura-playoffs',
)


end # module Worldfootball
