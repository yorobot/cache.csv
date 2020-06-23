require 'net/http'
require 'uri'
require 'json'
require 'pp'


module Footballdata
  BASE_URI = 'http://api.football-data.org/v2/'


  def self.competitions
    get( 'competitions?plan=TIER_ONE' )
  end


  def self.competition( code, year )
    get( "competitions/#{code}/matches?season=#{year}" )
    get( "competitions/#{code}/teams?season=#{year}" )
  end

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


    uri = URI.parse( service_uri )
    http = Net::HTTP.new( uri.host, uri.port )

    request = Net::HTTP::Get.new( uri.request_uri )

    token = ENV['FOOTBALLDATA']
    puts token

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

      File.open( "dl/#{path}.json", 'w:utf-8' ) { |f| f.write( txt ) }

      data
  end
end # module Footballdata


## data = Footballdata.competitions
## data = Footballdata.fr( 2019 )  ## 2018-19
## data = Footballdata.fr( 2017 )  ## 2017-18   -- requires subscription ???

Footballdata.eng( 2019 )
Footballdata.eng( 2018 )
Footballdata.eng( 2017 )
