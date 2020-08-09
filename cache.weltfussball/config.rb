##########
#  shared "standalone" / no-dependencies configuration for (re)use


module Worldfootball


LEAGUES = {
  'de.2'   => { slug: '2-bundesliga' },
  'de.cup' => { slug: 'dfb-pokal' },

  'at.1'   => { slug: 'aut-bundesliga' },
  'at.2'   => { slug: ->(season) {
                          season.start_year >= 2019 ? 'aut-2-liga' : 'aut-erste-liga' } },
  'at.cup' => { slug: 'aut-oefb-cup' },

  'ch.1'   => { slug: 'sui-super-league' },
  'ch.2'   => { slug: 'sui-challenge-league' },

  'eng.3'  => { slug: 'eng-league-one' },
  'eng.4'  => { slug: 'eng-league-two' },
  'eng.5'  => { slug: 'eng-national-league' },
  'eng.cup'   => { slug: 'eng-fa-cup' },    ## change key to eng.cup.fa or such??
  'eng.cup.l' => { slug: 'eng-league-cup' }, ## change key to ??

  'fr.1'  => { slug: 'fra-ligue-1' },
  'fr.2'  => { slug: 'fra-ligue-2' },

  'it.2'  => { slug: 'ita-serie-b' },

  'es.2'  => { slug: 'esp-segunda-division' },

  'ru.1'  => { slug: 'rus-premier-liga' },
  'ru.2'  => { slug: 'rus-1-division' },

  'tr.1'  => { slug: 'tur-sueperlig' },
  'tr.2'  => { slug: 'tur-1-lig' },

  # e.g. /swe-allsvenskan-2020/
  #      /swe-superettan-2020/
  'se.1'  => { slug: 'swe-allsvenskan' },
  'se.2'  => { slug: 'swe-superettan' },

  # e.g. /nor-eliteserien-2020/
  'no.1'  => { slug: 'nor-eliteserien' },

  # e.g. /isl-urvalsdeild-2020/
  'is.1'  => { slug: 'isl-urvalsdeild' },

  # e.g. /irl-premier-division-2019/
  'ie.1'  => { slug: 'irl-premier-division' },

  # e.g. /lux-nationaldivision-2020-2021/
  'lu.1' => { slug: 'lux-nationaldivision' },


  # /den-superliga-2020-2021/
  # /den-superliga-2019-2020-meisterschaft/
  # /den-superliga-2019-2020-abstieg/
  # /den-superliga-2019-2020-europa-league/
  'dk.1'  => {
    stages: {
    'regular'       => { name: 'Regular Season',          slug: 'den-superliga-{season}' },
    'championship'  => { name: 'Playoffs - Championship', slug: 'den-superliga-{season}-meisterschaft' },
    'relegation'    => { name: 'Playoffs - Relegation',   slug: 'den-superliga-{season}-abstieg' },
    'europa_finals' => { name: 'Europa League Finals',    slug: 'den-superliga-{season}-europa-league' },
   },
   format: ->( season ) {
    case season
    when Season.new('2020/21')
      %w[regular]     # just getting started
    when Season.new('2019/20')
      %w[regular championship relegation europa_finals]
    when Season.new('2018/19')
      %w[regular championship relegation europa_finals]
    else
      puts "!! ERROR - no configuration found for season >#{season}< for DK1 found; sorry"
      exit 1
    end
   }
  },


  'sco.1' => {
    stages: {
     'regular'      => { name: 'Regular Season',          slug: 'sco-premiership-{season}' },
     'championship' => { name: 'Playoffs - Championship', slug: 'sco-premiership-{end_year}-playoff' },  # note: only uses season.end_year!
     'relegation'   => { name: 'Playoffs - Relegation',   slug: 'sco-premiership-{end_year}-abstieg' },  # note: only uses season.end_year!
   },
   format: ->( season ) {
    case season
    when Season.new('2020/21')
      %w[regular]     # just getting started
    when Season.new('2019/20')
      %w[regular]     # covid-19 - no championship & relegation
    when Season.new('2018/19')
      %w[regular championship relegation]
    else
      puts "!! ERROR - no configuration found for season >#{season}< for SCO1 found; sorry"
      exit 1
    end
   }
  },


  # e.g. /fin-veikkausliiga-2019/
  #      /fin-veikkausliiga-2019-meisterschaft/
  #      /fin-veikkausliiga-2019-abstieg/
  #      /fin-veikkausliiga-2019-playoff-el/
  'fi.1' => {
    stages: {
     'regular'       => { name: 'Regular Season',          slug: 'fin-veikkausliiga-{season}' },
     'championship'  => { name: 'Playoffs - Championship', slug: 'fin-veikkausliiga-{season}-meisterschaft' },
     'challenger'    => { name: 'Playoffs - Challenger',   slug: 'fin-veikkausliiga-{season}-abstieg' },
     'europa_finals' => { name: 'Europa League Finals',    slug: 'fin-veikkausliiga-{season}-playoff-el' },
    },
    format: ->( season ) {
     case season
     when Season.new('2020')
       %w[regular]     # just getting started
     when Season.new('2019')
       %w[regular championship challenger europa_finals]
     else
       puts "!! ERROR - no configuration found for season >#{season}< for FI1 found; sorry"
       exit 1
     end
    }
  },


  # Championship play-offs
  # Europa League play-offs (Group A + Group B / Finals )

  # e.g. /bel-eerste-klasse-a-2020-2021/
  #      /bel-europa-league-playoffs-2018-2019-playoff/
  #       - Halbfinale
  #       - Finale
  'be.1' => {
    stages: {
     'regular'       => { name: 'Regular Season',                    slug: 'bel-eerste-klasse-a-{season}' },
     'championship'  => { name: 'Playoffs - Championship',           slug: 'bel-eerste-klasse-a-{season}-playoff-i' },
     'europa'        => { name: 'Playoffs - Europa League',          slug: 'bel-europa-league-playoffs-{season}' },  ## note: missing groups (A & B)
     'europa_finals' => { name: 'Playoffs - Europa League - Finals', slug: 'bel-europa-league-playoffs-{season}-playoff' },
    },
    format: ->( season ) {
      case season
      when Season.new('2020/21')
        %w[regular]     # just getting started
      when Season.new('2019/20')
        %w[regular]     # covid-19 - no championship & europa
      when Season.new('2018/19')
        %w[regular championship europa europa_finals]
      else
        puts "!! ERROR - no configuration found for season >#{season}< for BE1 found; sorry"
        exit 1
      end
    }
  },


# todo/fix: adjust date/time by -7 hours!!!
##  e.g. 25.07.2020	02:30  => 24.07.2020 19.30
#        11.01.2020	04:00  => 10.01.2020 21.00
#
# e.g. /mex-primera-division-2020-2021-apertura/
#      /mex-primera-division-2019-2020-clausura/
#      /mex-primera-division-2019-2020-apertura-playoffs/
#        - Viertelfinale
#        - Halbfinale
#        - Finale
#      /mex-primera-division-2018-2019-clausura-playoffs/
  'mx.1' => {
    stages: {
     'apertura'        => { name: 'Apertura',            slug: 'mex-primera-division-{season}-apertura' },
    'apertura_finals' => { name: 'Apertura - Liguilla', slug: 'mex-primera-division-{season}-apertura-playoffs' },
    'clausura'        => { name: 'Clausura',            slug: 'mex-primera-division-{season}-clausura' },
    'clausura_finals' => { name: 'Clausura - Liguilla', slug: 'mex-primera-division-{season}-clausura-playoffs' },
   },
   format: ->( season ) {
    case season
    when Season.new('2020/21')
      %w[apertura]     # just getting started
    when Season.new('2019/20')
      %w[apertura apertura_finals clausura]     # covid-19 - no liguilla
    when Season.new('2018/19')
      %w[apertura apertura_finals clausura clausura_finals]
    else
      puts "!! ERROR - no configuration found for season >#{season}< for MX1 found; sorry"
      exit 1
    end
   }
  },

}




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
