
LEAGUES =
{
############################
# Brazil
  'br.1' => { name:     'Brasileiro Série A',  ## league name
              basename: '1-seriea',
              path:     'brazil',              ## repo path
              lang:     'pt_BR',
            },

########################
# Russia
  'ru.1' => { name:     'Russian Premier League',
              basename: '1-premierliga',
              path:     'russia',
              lang:     'en',   ## note: use english for now
            },
  'ru.2' => { name:     'Russian 1. Division',
              basename: '2-division1',
              path:     'russia',
              lang:     'en',
            },

########################
# Italy
  'it.1' => { name:     'Italian Serie A',
              basename: '1-seriea',
              path:     'italy',
              lang:     'it',
            },
  'it.2' => { name:     'Italian Serie B',
              basename: '2-serieb',
              path:     'italy',
              lang:     'it',
            },

########################
# France
  'fr.1' => { name:     'French Ligue 1',
              basename: '1-ligue1',
              path:     'france',
              lang:     'fr',
          },
  'fr.2' => { name:     'French Ligue 2',
              basename: '2-ligue2',
              path:     'france',
              lang:     'fr',
            },

###################
# Spain / Espana
  'es.1' => { name:     'Primera División de España',
              basename: '1-liga',
              path:     'espana',
              lang:     'es',
            },
  'es.2' => { name:     'Segunda División de España',
              basename: '2-liga2',
              path:     'espana',
              lang:     'es',
            },
}

require_relative './leagues_eng'
require_relative './leagues_de'
require_relative './leagues_at'
require_relative './leagues_world'