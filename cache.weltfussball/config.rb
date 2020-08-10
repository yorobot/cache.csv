##########
#  shared "standalone" / no-dependencies configuration for (re)use


require_relative 'config/europe'
require_relative 'config/north_america'
require_relative 'config/pacific'
require_relative 'config/asia'



module Worldfootball

LEAGUES = [LEAGUES_EUROPE,
           LEAGUES_NORTH_AMERICA,
           LEAGUES_PACIFIC,
           LEAGUES_ASIA].reduce({}) { |all,h| all.merge!( h ); all }



class League
    ## inner (helper) class Stage
    class Stage
      def initialize( league, key, data )
        @league = league
        @key    = key
        @data   = data
      end

      def league() @league; end
      def key()    @key; end
      def name()   @data[:name]; end

      def slug( season: )
        slug = @data[ :slug ]
        slug = slug.call( season )  if slug.is_a?( Proc )

        if slug.nil?
          puts "!! ERROR - no slug found for stage >#{@key}< for league >#{@league.key}<; add to leagues tables"
          exit 1
        end

        ## note: fill-in/check for place holders too
        slug = if slug.index( '{season}' )
                 slug.sub( '{season}', season.to_path( :long ) )  ## e.g. 2010-2011
               elsif slug.index( '{end_year}' )
                 slug.sub( '{end_year}', season.end_year.to_s )   ## e.g. 2011
               else
                 ## assume convenience fallback - append regular season
                 "#{slug}-#{season.to_path( :long )}"
              end

        puts "  slug=>#{slug}<"

        slug
      end
    end # inner class Stage


    ### start class League
    def initialize( key, data )
      @key  = key
      @data = data
    end

    def key()   @key; end

    def stages( season: )
      ## check for league format / stages
      ##   return array (of strings) or nil (for no stages - "simple" format)
      league_format = @data[:format]
      stages = if league_format
                 league_format.call( season )
               else
                 nil ## not found; assume always "simple/regular" format w/o stages
               end

      ## map to key to Stage class/struct
      stages = stages.map{ |key| Stage.new( self, key, @data[:stages][key] )  }  if stages

      stages
    end


    def slug( season: )
      slug =  @data[ :slug ]
      slug =  slug.call( season )  if slug.is_a?( Proc )

      if slug.nil?
        puts "!! ERROR - no slug found for league >#{@key}<; add to leagues tables"
        exit 1
      end

      ## note: fill-in/check for place holders too
      slug = if slug.index( '{season}' )
               slug.sub( '{season}', season.to_path( :long ) )  ## e.g. 2010-2011
             elsif slug.index( '{end_year}' )
               slug.sub( '{end_year}', season.end_year.to_s )   ## e.g. 2011
             else
               ## assume convenience fallback - append regular season
               "#{slug}-#{season.to_path( :long )}"
            end

      puts "  slug=>#{slug}<"

      slug
    end
  end # class League



  def self.find_league( key )  ## league info lookup
    data = LEAGUES[ key ]
    if data.nil?
      puts "!! ERROR - no league found for >#{key}<; add to leagues tables"
      exit 1
    end
    League.new( key, data )   ## use a convenience wrapper for now
  end

end # module Worldfootball
