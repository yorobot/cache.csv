
module Fbref
  BASE_URL = 'https://fbref.com/en'

  LEAGUES = {
    ## todo/check: shorten - (auto-)add to base_url - comps/ - why? why not?
     'at.1' => {
       '2020/21' => 'comps/56/schedule/Austrian-Bundesliga-Scores-and-Fixtures',
       '2019/20' => 'comps/56/3213/schedule/2019-2020-Austrian-Bundesliga-Scores-and-Fixtures',
       '2018/19' => 'comps/56/2352/schedule/2018-2019-Austrian-Bundesliga-Scores-and-Fixtures',
      },
    'eng.1' => {
       '2020/21' => 'comps/9/schedule/Premier-League-Scores-and-Fixtures',
     },

    'mx.1' => {
       '2020/21' => 'comps/31/schedule/Liga-MX-Scores-and-Fixtures',
       '2019/20' => 'comps/31/3267/schedule/2019-2020-Liga-MX-Scores-and-Fixtures',
       '2018/19' => 'comps/31/2252/schedule/2018-2019-Liga-MX-Scores-and-Fixtures',
    },

    'jp.1' => {
       '2020' => 'comps/25/schedule/J1-League-Scores-and-Fixtures',
       '2019' => 'comps/25/3923/schedule/2019-J1-League-Scores-and-Fixtures',
       '2018' => 'comps/25/1761/schedule/2018-J1-League-Scores-and-Fixtures',
    },
  }


  def self.schedule_url( league:, season: )
     season = Season.parse( season )

     pages = LEAGUES[ league ]
     if pages.nil?
       puts "!! ERROR - no pages (urls) configured for league >#{league}<"
       exit 1
     end
     page = pages[ season.key ]
     if pages.nil?
      puts "!! ERROR - no page (url) configured for season >#{season}< for league >#{league}<; available seasons include:"
      pp pages
      exit 1
    end

    "#{BASE_URL}/#{page}"
  end
end # module Fbref
