module Footballdata
  BASE_URL = 'http://api.football-data.org/v2/'


  def self.competitions_tier_one
    get( 'competitions?plan=TIER_ONE' )
  end

  def self.competitions_tier_two
    get( 'competitions?plan=TIER_TWO' )
  end

  def self.competitions_tier_three
    get( 'competitions?plan=TIER_THREE' )
  end



  def self.competition( code, year )
    get( "competitions/#{code}/matches?season=#{year}" )
    get( "competitions/#{code}/teams?season=#{year}" )
  end


=begin
  def self.matches
    # note: Specified period must not exceed 10 days.

    ## try query (football) week by week - tuesday to monday!!
    ##  note: TIER_ONE does NOT include goals!!!
    code       = 'FL1'
    start_date = '2019-08-09'
    end_date   = '2019-08-16'

    get( "matches?competitions=#{code}&dateFrom=#{start_date}&dateTo=#{end_date}" )
  end
=end


  def self.fr( year )
    # FL1 - Ligue 1, France
    #   9 seasons | 2019-08-09 - 2020-05-31 / matchday 38
    #
    # 2019 => 2019/20
    # 2018 => 2018/19
    # 2017 => xxx 2017-18 - requires subscription !!!
    competition( 'FL1', year )
  end

  def self.br( year )
    # BSA - Série A, Brazil
    #   4 seasons | 2020-05-03 - 2020-12-06 / matchday 10
    #
    #  2020 => 2020
    #  2019 => 2019
    #  2018 => 2018
    #  2017 => xxx 2017 - requires subscription !!!
    competition( 'BSA', year )
  end

  def self.de( year )
    # BL1 - Bundesliga            , Germany        24 seasons | 2019-08-16 - 2020-06-27 / matchday 34
    competition( 'BL1', year )
  end

  def self.nl( year )
    # DED - Eredivisie            , Netherlands    10 seasons | 2019-08-09 - 2020-03-08 / matchday 34
    competition( 'DED', year )
  end

  def self.pt( year )
    # PPL - Primeira Liga         , Portugal        9 seasons | 2019-08-10 - 2020-07-26 / matchday 28
    competition( 'PPL', year )
  end

  def self.es( year )
    # PD  - Primera Division      , Spain          27 seasons | 2019-08-16 - 2020-07-19 / matchday 31
    competition( 'PD', year )
  end

  def self.it( year )
    # SA  - Serie A               , Italy          15 seasons | 2019-08-24 - 2020-08-02 / matchday 27
    competition( 'SA', year )
  end

  def self.eng( year )
   # PL  - Premier League        , England        27 seasons | 2019-08-09 - 2020-07-25 / matchday 31
   #  ELC - Championship          , England         3 seasons | 2019-08-02 - 2020-07-22 / matchday 38
   #
   # 2019 => 2019/20
   # 2018 => 2018/19
   # 2017 => xxx 2017-18 - requires subscription !!!

   competition( 'PL', year )
   competition( 'ELC', year )
  end


  def self.cl( year )
    # CL  - UEFA Champions League , Europe         19 seasons | 2019-06-25 - 2020-05-30 / matchday 6
    competition( 'CL', year )
  end


  def self.get( service )
    service_url = BASE_URL + service
    puts service_url

    token = ENV['FOOTBALLDATA']
    ## note: because of public workflow log - do NOT output token
    ## puts token

    headers = {}
    headers['X-Auth-Token'] = token    if token
    headers['User-Agent']   = 'ruby'
    headers['Accept']       = '*/*'

    ## note: add format: 'json' for pretty printing json (before) save in cache
    response = Webget.call( service_url, headers: headers )

    ## for debugging print pretty printed json first 400 chars
    puts JSON.pretty_generate( response.json )[0..400]

    exit 1  if response.status.nok?   # e.g. HTTP status code != 200
  end
end # module Footballdata

