module Worldfootball

LEAGUES_ASIA = {

=begin
2020                           -- >/alle_spiele/kor-k-league-1-2020/<
2019 Meisterschaft             -- >/alle_spiele/kor-k-league-1-2019-meisterschaft/<
2019 Abstieg                   -- >/alle_spiele/kor-k-league-1-2019-abstieg/<
2019                           -- >/alle_spiele/kor-k-league-1-2019/<
2018 Meisterschaft             -- >/alle_spiele/kor-k-league-1-2018-meisterschaft/<
2018 Abstieg                   -- >/alle_spiele/kor-k-league-1-2018-abstieg/<
2018                           -- >/alle_spiele/kor-k-league-classic-2018/<
2017 Meisterschaft             -- >/alle_spiele/kor-k-league-classic-2017-meisterschaft/<
2017 Abstieg                   -- >/alle_spiele/kor-k-league-classic-2017-abstieg/<
2017                           -- >/alle_spiele/kor-k-league-classic-2017/<
2016 Meisterschaft             -- >/alle_spiele/kor-k-league-classic-2016-meisterschaft/<
2016 Abstieg                   -- >/alle_spiele/kor-k-league-classic-2016-abstieg/<
2016                           -- >/alle_spiele/kor-k-league-2016/<
2015 Meisterschaft             -- >/alle_spiele/kor-k-league-2015-meisterschaft/<
2015 Abstieg                   -- >/alle_spiele/kor-k-league-2015-abstieg/<
2015                           -- >/alle_spiele/kor-k-league-2015/<
=end

### todo/fix: time-zone offset!!!!!!!!
  # /kor-k-league-1-2020/
  # /kor-k-league-1-2019-meisterschaft/
  # /kor-k-league-1-2019-abstieg/
 'kr.1' => {
  stages: {
    'regular'       => { name: 'Regular Season',          slug: 'kor-k-league-1-{season}' },
    'championship'  => { name: 'Playoffs - Championship', slug: 'kor-k-league-1-{season}-meisterschaft' },
    'relegation'    => { name: 'Playoffs - Relegation',   slug: 'kor-k-league-1-{season}-abstieg' },
   },
   format: ->( season ) {
    case season
    when Season.new('2020')
      %w[regular]     # just getting started
    when Season.new('2019')
      %w[regular championship relegation]
    else
      puts "!! ERROR - no configuration found for season >#{season}< for KR1 found; sorry"
      exit 1
    end
   }
  },

}

end # module Worldfootball


