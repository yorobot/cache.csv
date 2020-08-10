module Worldfootball

LEAGUES_NORTH_AMERICA = {

# todo/fix: adjust date/time by -6 or 7 hours!!!
#   /can-canadian-championship-2020/
#     - Qual. 1. Runde
#     - Qual. 2. Runde
#     - Qual. 3. Runde
#   todo/fix: check for leagues - premier league? championship? soccer league?
#  'ca.1' => { slug: 'can-canadian-championship' },



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

end # module Worldfootball

