require 'pp'
require 'time'
require 'date'
require 'fileutils'

require 'uri'
require 'net/http'
require 'net/https'

require 'json'
require 'yaml'




module Webcache


 class Configuration
    ## root directory - todo/check: find/use a better name - why? why not?
    def root()       @root || './dl'; end
    def root=(value) @root = value; end
 end # class Configuration


 ## lets you use
 ##   Webcache.configure do |config|
 ##      config.root = './cache'
 ##   end
 def self.configure() yield( config ); end
 def self.config()    @config ||= Configuration.new;  end


 ## add "high level" root convenience helpers
 def self.root()       config.root; end
 def self.root=(value) config.root = value; end


 ### "interface" for "generic" cache storage (might be sqlite database or filesystem)
 def self.cache() @cache ||= DiskCache.new; end

 def self.record( url, response, format: 'html' )
   cache.record( url, response, format: format );
 end
 def self.cached?( url ) cache.cached?( url ); end
 class << self
   alias_method :exist?, :cached?
 end
 def self.url_to_id( url ) cache.url_to_id( url ); end  ## todo/check: rename to just id or something - why? why not?
 def self.read( url ) cache.read( url ); end


class DiskCache
  def cached?( url )
    body_path = "#{Webcache.root}/#{url_to_path( url )}"
    File.exist?( body_path )
  end
  alias_method :exist?, :cached?


  def read( url )
    body_path = "#{Webcache.root}/#{url_to_path( url )}"
    File.open( body_path, 'r:utf-8' ) {|f| f.read }
  end


  ## add more save / put / etc. aliases - why? why not?
  ##  rename to record_html - why? why not?
  def record( url, response, format: 'html' )

    body_path = "#{Webcache.root}/#{url_to_path( url )}"
    meta_path = "#{body_path}.meta.txt"

    ## make sure path exits
    FileUtils.mkdir_p( File.dirname( body_path ) )


    ## note - for now always assume utf8!!!!!!!!!
    body = response.body.to_s
    body = body.force_encoding( Encoding::UTF_8 )


    ## todo/check: verify content-type - why? why not?
    if format == 'json'
      data = JSON.parse( body )
      File.open( body_path, 'w:utf-8' ) {|f| f.write( JSON.pretty_generate( data )) }
    else
      File.open( body_path, 'w:utf-8' ) {|f| f.write( body ) }
    end

    File.open( meta_path, 'w:utf-8' ) do |f|
      response.each_header do |key, value|  # Iterate all response headers.
        f.write( "#{key}: #{value}" )
        f.write( "\n" )
      end
    end
  end


  ### note: use file path as id for DiskCache  (is different for DbCache/SqlCache?)
  ##    use file:// instead of disk:// - why? why not?
  def url_to_id( str ) "disk://#{url_to_path( str )}"; end


  ### helpers
  def url_to_path( str )
    ## map url to file path
    uri = URI.parse( str )

    ## note: ignore scheme (e.g. http/https)
    ##         and  post  (e.g. 80, 8080, etc.) for now
    ##    always downcase for now (internet domain is case insensitive)
    host_dir = uri.host.downcase

    ## "/this/is/everything?query=params"
    ##   cut-off leading slash and
    ##    convert query ? =
    req_path = uri.request_uri[1..-1]



    ### special "prettify" rule for weltfussball
    ##   /eng-league-one-2019-2020/  => /eng-league-one-2019-2020.html
    if host_dir.index( 'weltfussball.de' ) ||
       host_dir.index( 'worldfootball.net' )
          if req_path.end_with?( '/' )
             req_path = "#{req_path[0..-2]}.html"
          else
            puts "ERROR: expected request_uri for >#{host_dir}< ending with '/'; got: >#{req_path}<"
            exit 1
          end
    elsif host_dir.index( 'football-data.org' )
      req_path = req_path.sub( 'v2/', '' )  # shorten - cut off v2/

      ## flattern - make a file path - for auto-save
      ##   change ? to -I-
      ##   change / to ~~
      ##   change = to ~
      req_path = req_path.gsub( '?', '-I-' )
                         .gsub( '/', '~~' )
                         .gsub( '=', '~')

      req_path = "#{req_path}.json"
    else
      ## no special rule
    end

    page_path = "#{host_dir}/#{req_path}"
    page_path
  end
end # class DiskCache


end  # module Webcache





############################
###############################

class Webclient

  class Response   # nested class - wrap Net::HTTP::Response
    def initialize( response )
      @response = response
    end
    def raw() @response; end

    def code()    @response.code.to_i; end
    def message() @response.message;   end



    class Status  # nested (nested) class
      def initialize( response )
        @response = response
      end
      def code() @response.code.to_i; end
      def ok?()  code == 200; end
      def nok?() code != 200; end
      def message() @response.message; end
    end
    def status() @status ||= Status.new( self ); end
  end # (nested) class Response


def self.get( url, headers: {} )

  uri = URI.parse( url )
  http = Net::HTTP.new( uri.host, uri.port )

  if uri.instance_of? URI::HTTPS
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  request = Net::HTTP::Get.new( uri.request_uri )

  ### add (custom) headers if any
  ##  check/todo: is there are more idiomatic way for Net::HTTP ???
  ##   use
  ##     request = Net::HTTP::Get.new( uri.request_uri, headers )
  ##    why? why not?
  ##  instead of e.g.
  ##   request['X-Auth-Token'] = 'xxxxxxx'
  ##   request['User-Agent']   = 'ruby'
  ##   request['Accept']       = '*/*'
  if headers && headers.size > 0
    headers.each do |key,value|
      request[ key ] = value
    end
  end


  response = http.request( request )

  ## note: return "unified" wrapped response
  Response.new( response )
end  # method self.get

end  # class Webclient





############################
###############################

class Webget   # a web (go get) crawler

  class Configuration  ## nested class

    #######################
    ## accessors
    def sleep()       @sleep || 3; end     ### todo/check: use delay / wait or such?
    def sleep=(value) @sleep = value; end

  end # (nested) class Configuration

  ## lets you use
  ##   Webget.configure do |config|
  ##      config.sleep = 10
  ##   end
  def self.configure() yield( config ); end
  def self.config()    @config ||= Configuration.new;  end



  def self.call( url, headers: {} )  ## assumes json format
    puts "  sleep #{config.sleep} sec(s)..."
    sleep( config.sleep )   ## slow down - sleep 3secs before each http request

    response = Webclient.get( url, headers: headers )

    if response.status.ok?  ## must be HTTP 200
      puts "#{response.code} #{response.message}"
      Webcache.record( url, response, format: 'json' )
    else
      ## todo/check - log error
      puts "!! ERROR - #{response.code} #{response.message}:"
      pp response
    end

    ## to be done / continued
    response
  end  # method self.call


  def self.page( url, headers: {} )  ## assumes html format
    puts "  sleep #{config.sleep} sec(s)..."
    sleep( config.sleep )   ## slow down - sleep 3secs before each http request

    response = Webclient.get( url, headers: headers )

    if response.status.ok?  ## must be HTTP 200
      puts "#{response.code} #{response.message}"
      Webcache.record( url, response )   ## assumes format: html (default)
    else
      ## todo/check - log error
      puts "!! ERROR - #{response.code} #{response.message}:"
      pp response
    end

    ## to be done / continued
    response
  end  # method self.page

end  # class Webget




## add convenience alias for camel case / alternate different spelling
WebCache  = Webcache
WebClient = Webclient
WebGet    = Webget

## use Webgo as (alias) name (keep reserver for now) - why? why not?
WebGo    = Webget
Webgo    = Webget
