module Worldfootball


class Configuration
   #########
   ## nested configuration classes - use - why? why not?
   class Cache
      def reports_dir()    @reports_dir   || './dl2'; end
      def schedules_dir()  @schedules_dir || './dl'; end

      def reports_dir=(value)   @reports_dir = value; end
      def schedules_dir=(value) @schedules_dir = value; end
   end


   #######################
   ## accessors
  def sleep()       @sleep || 2; end
  def sleep=(value) @sleep = value; end


  def cache()  @cache ||= Cache.new; end
end # class Configuration


## lets you use
##   Worldfootball.configure do |config|
##      config.sleep = 4
##      config.cache.reports_dir = "??"
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end

end   # module Worldfootball