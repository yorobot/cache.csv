###########################
#  note: split code in two parts
#    metal  - "bare" basics - no ref to sportdb
#    and rest / convert  with sportdb references / goodies


require_relative 'metal'


require_relative '../../csv'


def read_json( path )
  puts "path=>#{path}<"
  txt = File.open( path, 'r:utf-8' ) {|f| f.read }
  data = JSON.parse( txt )
  data
end




module Footballdata

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

end  # module Footballdata


###########################
## our own code
require_relative 'convert/config'
require_relative 'convert/stat'
require_relative 'convert/convert'
require_relative 'convert/convert_cl'


