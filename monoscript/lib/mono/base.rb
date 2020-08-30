module Mono

  def self.root   ## root of single (monorepo) source tree
    @@root ||= begin
        ## todo/fix:
        ##  check if windows - otherwise use /sites
        ##  check if root directory exists?
        'c:/sites'
    end
  end

end  ## module Mono


