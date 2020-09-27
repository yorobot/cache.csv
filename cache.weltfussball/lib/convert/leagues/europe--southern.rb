
module Worldfootball

LEAGUES_EUROPE.merge!({

  # /ita-serie-a-2019-2020/
  # /ita-serie-b-2020-2021/
  'it.1' =>  { pages: 'ita-serie-a' },
  'it.2' =>  { pages: 'ita-serie-b' },

  # /por-primeira-liga-2019-2020/
  # /por-segunda-liga-2019-2020/
  'pt.1' =>  { pages: 'por-primeira-liga' },
  'pt.2' =>  { pages: 'por-segunda-liga' },

  # /esp-primera-division-2019-2020/
  'es.1'  => { pages: 'esp-primera-division' },
  'es.2'  => { pages: 'esp-segunda-division' },

  # /tur-sueperlig-2020-2021/
  'tr.1'  => { pages: 'tur-sueperlig' },
  'tr.2'  => { pages: 'tur-1-lig' },

  # /gre-super-league-2020-2021/
  'gr.1'  => { pages: 'gre-super-league' },


  ## todo/check: add europe southeastern or balkans - why? why not?
  # e.g. /cro-1-hnl-2020-2021/
  'hr.1' => { pages: 'cro-1-hnl' },

})

end