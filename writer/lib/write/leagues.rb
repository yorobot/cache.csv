module Writer

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



def self.write_it1( season, source: 'one' )  write( 'it.1', season, source: source ); end
def self.write_it2( season, source: 'two' )  write( 'it.2', season, source: source ); end

def self.write_fr1( season, source: 'leagues' )  write( 'fr.1', season, source: source ); end
def self.write_fr2( season, source: 'two' )      write( 'fr.2', season, source: source ); end

def self.write_es1( season, source: 'one' )      write( 'es.1', season, source: source ); end
def self.write_es2( season, source: 'two' )      write( 'es.2', season, source: source ); end

def self.write_ru1( season, source: 'two' )  write( 'ru.1', season, source: source ); end
def self.write_ru2( season, source: 'two' )  write( 'ru.2', season, source: source ); end


def self.write_br1( season, source: 'one' )     write( 'br.1', season, source: source ); end


end   # module Writer
