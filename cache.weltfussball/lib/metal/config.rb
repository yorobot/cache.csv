module Worldfootball


class Configuration

  #######################
  ## accessors
  def sleep()       @sleep || 3; end
  def sleep=(value) @sleep = value; end

end # class Configuration


## lets you use
##   Worldfootball.configure do |config|
##      config.sleep = 4
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end

end   # module Worldfootball