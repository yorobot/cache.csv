module Footballdata


class Configuration
   #########
   ## nested configuration classes - use - why? why not?
   class Cache
      def download_dir()       @download_dir || './dl'; end
      def download_dir=(value) @download_dir = value; end
   end


   #######################
   ## accessors
  def sleep()       @sleep || 3; end
  def sleep=(value) @sleep = value; end


  def cache()  @cache ||= Cache.new; end
end # class Configuration


## lets you use
##   Footballdata.configure do |config|
##      config.sleep = 4
##      config.cache.download_dir = "??"
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end

end   # module Footballdata