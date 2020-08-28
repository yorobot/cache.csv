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

##############################
# Mexico
#
#  - Viertelfinale
#  - Halbfinale
#  - Finale

  'mx.1' => { name:     'Liga MX',
              basename: '1-ligamx',   ## note: gets "overwritten" by stages (see below)
              path:     'mexico',
              lang:     'es',
              stages: [{basename: '1-apertura',          names: ['Apertura']},
                       {basename: '1-apertura_liguilla', names: ['Apertura - Liguilla']},
                       {basename: '1-clausura',          names: ['Clausura']},
                       {basename: '1-clausura_liguilla', names: ['Clausura - Liguilla']},
                      ],
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



def self.write_it1( season, source: ) write( 'it.1', season, source: source ); end
def self.write_it2( season, source: ) write( 'it.2', season, source: source ); end

def self.write_fr1( season, source: ) write( 'fr.1', season, source: source ); end
def self.write_fr2( season, source: ) write( 'fr.2', season, source: source ); end

def self.write_es1( season, source: ) write( 'es.1', season, source: source ); end
def self.write_es2( season, source: ) write( 'es.2', season, source: source ); end



def self.write_br1( season, source: ) write( 'br.1', season, source: source ); end

def self.write_mx1( season, source: ) write( 'mx.1', season, source: source ); end

end   # module Writer
