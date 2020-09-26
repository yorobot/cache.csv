module Footballdata
  BASE_URI = 'http://api.football-data.org/v2/'


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
    service_uri = BASE_URI + service

    ## make a file path - for auto-save
    ##   change ? to -I-
    ##   change / to ~~
    ##   change = to ~
    path = service.gsub( '?', '-I-' )
                  .gsub( '/', '~~' )
                  .gsub( '=', '~')

    puts path
    puts service_uri


    puts "  sleep #{config.sleep} sec(s)..."
    sleep( config.sleep )   ## slow down - sleep 2secs before each http request

    uri = URI.parse( service_uri )
    http = Net::HTTP.new( uri.host, uri.port )

    request = Net::HTTP::Get.new( uri.request_uri )

    token = ENV['FOOTBALLDATA']
    ## note: because of public workflow log - do NOT output token
    ## puts token

    request['X-Auth-Token'] = token    if token
    request['User-Agent']   = 'ruby'
    request['Accept']       = '*/*'

    response = http.request( request )

    puts response.code             # => '301'  note: code is a string!!!
    puts response.code.class.name


    # Get specific header
    puts response["content-type"]
    # => "text/html; charset=UTF-8"

    # Iterate all response headers.
    response.each_header do |key, value|
      puts "#{key} => #{value}"
    end
    # => "location => http://www.google.com/"
    # => "content-type => text/html; charset=UTF-8"
    # ...

      # Note: Net::HTTP will NOT set encoding UTF-8 etc.
      # will be set to ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here
      # thus, set/force encoding to utf-8
      txt = response.body.to_s
      txt = txt.force_encoding( Encoding::UTF_8 )
      txt
      ## puts txt

      data = JSON.parse( txt )

      txt = JSON.pretty_generate( data )
      puts txt[0..400]


      if response.code == '200'
        download_path = "#{config.cache.download_dir}/#{path}.json"
        File.open( download_path, 'w:utf-8' ) { |f| f.write( txt ) }
      else
        puts "!! ERROR - #{response.code}:"
        pp response
        exit 1
      end

      data
  end
end # module Footballdata
