##########
#  shared "standalone" / no-dependencies configuration for (re)use


module Worldfootball


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
}


def self.sco1( season )
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
end

LEAGUES.merge!(
  'sco.1'              => 'sco-premiership',
   # -or -
  'sco.1.regular'      => 'sco-premiership-{season}',
  'sco.1.championship' => 'sco-premiership-{end_year}-playoff',   # sco-premiership-2019-playoff
  'sco.1.relegation'   => 'sco-premiership-{end_year}-abstieg'   # sco-premiership-2019-abstieg
)


# Championship play-offs
# Europa League play-offs (Group A + Group B / Finals )


def self.be1( season )
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
end

# https://www.weltfussball.de/alle_spiele/bel-eerste-klasse-a-2020-2021/
# https://www.weltfussball.de/alle_spiele/bel-europa-league-playoffs-2018-2019-playoff/
#   - Halbfinale
#   - Finale
LEAGUES.merge!(
  'be.1'               => 'bel-eerste-klasse-a',
   # -or -
  'be.1.regular'       => 'bel-eerste-klasse-a-{season}',
  'be.1.championship'  => 'bel-eerste-klasse-a-{season}-playoff-i',
  'be.1.europa'        => 'bel-europa-league-playoffs-{season}',  ## note: missing groups (A & B)
  'be.1.europa_finals' => 'bel-europa-league-playoffs-{season}-playoff',
)


end # module Worldfootball
