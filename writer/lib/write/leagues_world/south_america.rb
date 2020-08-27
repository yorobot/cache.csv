module Writer


LEAGUES.merge!(
  'ar.1' => { name:     'Argentina Primera Division',
              basename: '1-primeradivision',
              path:     'world/south-america/argentina',
              lang:     'es_AR',
            },

)

def self.write_ar( season, source: ) write( 'ar.1', season, source: source ); end


end   # module Writer
