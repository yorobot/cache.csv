###
#
# shared base functionality for read(ing)

require 'json'
require 'date'
require 'pp'

LEAGUES = {
  'eng.1' => 'PL',     # incl. team(s) from wales
  'eng.2' => 'ELC',
  'es.1'  => 'PD',
  'pt.1'  => 'PPL',
  'de.1'  => 'BL1',
  'nl.1'  => 'DED',
  'fr.1'  => 'FL1',    # incl. team(s) monaco
  'it.1'  => 'SA',
  'br.1'  => 'BSA',

  ## todo/check: use champs and NOT cl - why? why not?
  'cl' => 'CL',    ## note: cl is country code for chile!! - use champs - why? why not?
}

# e.g.
# Cardiff City FC | Cardiff  › Wales  - Cardiff City Stadium, Leckwith Road Cardiff CF11 8AZ
# AS Monaco FC | Monaco  › Monaco     - Avenue des Castellans Monaco 98000


MODS = {
  'br.1' => {
         'América FC' => 'América MG',   # in year 2018
            },
  'pt.1'  => {
         'Vitória SC' => 'Vitória Guimarães',  ## avoid easy confusion with Vitória SC <=> Vitória FC
         'Vitória FC' => 'Vitória Setúbal',
           },
}


def read_json( path )
  puts "path=>#{path}<"
  txt = File.open( path, 'r:utf-8' ) {|f| f.read }
  data = JSON.parse( txt )
  data
end


class Stat      ## rename to match stat or something why? why not?
  def initialize
    @data = {}
  end

  def [](key) @data[ key ]; end

  def update( match )
     ## keep track of some statistics
     stat = @data[:all] ||= { stage:    Hash.new( 0 ),
                              duration: Hash.new( 0 ),
                              status:   Hash.new( 0 ),
                              group:    Hash.new( 0 ),
                              matchday: Hash.new( 0 ),

                              matches:  0,
                              goals:    0,
                            }

     stat[:stage][ match['stage'] ]   += 1
     stat[:group][ match['group'] ]  += 1
     stat[:status][ match['status'] ]  += 1
     stat[:matchday][ match['matchday'] ]  += 1

     score = match['score']

     stat[:duration][ score['duration'] ] += 1   ## track - assert always REGULAR

     stat[:matches] += 1
     stat[:goals]   += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
     stat[:goals]   += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']


     stage_key = match['stage'].downcase.to_sym  # e.g. :regular_season
     stat = @data[ stage_key ] ||= { duration: Hash.new( 0 ),
                                     status:   Hash.new( 0 ),
                                     group:    Hash.new( 0 ),
                                     matchday: Hash.new( 0 ),

                                     matches:  0,
                                     goals:    0,
                                  }
     stat[:group][ match['group'] ]  += 1
     stat[:status][ match['status'] ]  += 1
     stat[:matchday][ match['matchday'] ]  += 1

     stat[:duration][ score['duration'] ] += 1   ## track - assert always REGULAR

     stat[:matches] += 1
     stat[:goals]   += score['fullTime']['homeTeam'].to_i  if score['fullTime']['homeTeam']
     stat[:goals]   += score['fullTime']['awayTeam'].to_i  if score['fullTime']['awayTeam']
  end
end  # class Stat

