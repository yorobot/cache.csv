
LEAGUES.merge!(
  'ar.1' => { name:     'Argentina Primera Division',
              basename: '1-primeradivision',
              path:     'world/south-america/argentina',
              lang:     'es_AR',
            },

)

def write_ar( season, source: ) write_worker( 'ar.1', season, source: source ); end

