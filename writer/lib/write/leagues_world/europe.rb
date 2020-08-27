module Writer

LEAGUES.merge!(
  'hu.1' => { name:     'Hungarian NB I',
              basename: '1-nbi',
              path:     'world/europe/hungary',
            },
  'gr.1' => { name:     'Super League Greece',
              basename: '1-superleague',
              path:     'world/europe/greece',
            },
  'pt.1' => { name:     'Portuguese Primeira Liga',
              basename: '1-primeiraliga',
              path:     'world/europe/portugal',
              lang:     'pt_PT',
            },
  'ch.1' => { name:     'Swiss Super League',
              basename: '1-superleague',
              path:     'world/europe/switzerland',
              lang:     'de_CH',
            },
  'ch.2' => { name:     'Swiss Challenge League',
              basename: '2-challengeleague',
              path:     'world/europe/switzerland',
              lang:     'de_CH',
            },
  'tr.1' => { name:     'Turkish Süper Lig',
              basename: '1-superlig',
              path:     'world/europe/turkey',
            },
  'tr.2' => { name:     'Turkish 1. Lig',
              basename: '2-lig1',
              path:     'world/europe/turkey',
            },


  'is.1' => { name:     'Iceland Urvalsdeild',
              basename: '1-urvalsdeild',
              path:     'world/europe/iceland',
            },
  'sco.1' => { name:     'Scottish Premiership',
               basename: '1-premiership',
               path:     'world/europe/scotland',
               stages:  [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation' ]]
             },
  'ie.1' => { name:     'Irish Premier Division',
              basename: '1-premierdivision',
              path:     'world/europe/ireland',
            },

  'fi.1' => { name: 'Finland Veikkausliiga',  ## note: make optional!!! override here (otherwise (re)use "regular" lookup "canonical" name from league!!!)
              basename: '1-veikkausliiga',
              path:     'world/europe/finland',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Challenger',
                          'Europa League Finals' ]]
            },
 'se.1'  => { name:     'Sweden Allsvenskan',
                basename: '1-allsvenskan',
                path:     'world/europe/sweden',
              },
   'se.2'  => { name:     'Sweden Superettan',
                basename: '2-superettan',
                path:     'world/europe/sweden',
              },
   'no.1'  => { name:     'Norwegian Eliteserien',
                basename: '1-eliteserien',
                path:     'world/europe/norway'
              },
   'dk.1'  => { name:     'Denmark Superligaen',
                basename: '1-superligaen',
                path:     'world/europe/denmark',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },

   'lu.1'  => { name:     'Luxembourger First Division',
                basename: '1-nationaldivision',
                path:     'world/europe/luxembourg',
              },
   'be.1'  => { name:     'Belgian First Division A',
                basename: '1-firstdivisiona',
                path:     'world/europe/belgium',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Europa League',
                           'Playoffs - Europa League - Finals']]
               },
    'nl.1' =>  { name:     'Dutch Eredivisie',
                 basename: '1-eredivisie',
                 path:     'world/europe/netherlands',
               },
    'cz.1' => { name:     'Czech First League',
                basename: '1-firstleague',
                path:     'world/europe/czech-republic',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Europa League Play-off',
                           'Playoffs - Relegation'
                          ]]
              },
  'sk.1' =>   { name:     'Slovakia First League',
                basename: '1-superliga',
                path:     'world/europe/slovakia',
                stages:  [['Regular Season'],
                          ['Playoffs - Championship',
                           'Playoffs - Relegation',
                           'Europa League Finals']]
              },
  'hr.1'  =>  { name:     'Croatia 1. HNL',
                basename: '1-hnl',
                path:     'world/europe/croatia',
              },
  'pl.1' => { name:     'Poland Ekstraklasa',
              basename: '1-ekstraklasa',
              path:     'world/europe/poland',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation']]
            },

  'ua.1' => { name:     'Ukraine Premier League',
              basename: '1-premierleague',
              path:     'world/europe/ukraine',
              stages:   [['Regular Season'],
                         ['Playoffs - Championship',
                          'Playoffs - Relegation',
                          'Europa League Finals']]
            },
)


def self.write_hu1( season, source: ) write( 'hu.1', season, source: source ); end
def self.write_gr1( season, source: ) write( 'gr.1', season, source: source ); end

def self.write_pt1( season, source: ) write( 'pt.1', season, source: source ); end

def self.write_ch1( season, source: ) write( 'ch.1', season, source: source ); end
def self.write_ch2( season, source: ) write( 'ch.2', season, source: source ); end

def self.write_tr1( season, source: ) write( 'tr.1', season, source: source ); end
def self.write_tr2( season, source: ) write( 'tr.2', season, source: source ); end


def self.write_be1( season, source: ) write( 'be.1', season, source: source ); end
def self.write_nl1( season, source: ) write( 'nl.1', season, source: source ); end
def self.write_lu1( season, source: ) write( 'lu.1', season, source: source ); end

def self.write_is1( season, source: ) write( 'is.1', season, source: source ); end
def self.write_ie1( season, source: ) write( 'ie.1', season, source: source ); end
def self.write_sco1( season, source: ) write( 'sco.1', season, source: source ); end

def self.write_dk1( season, source: ) write( 'dk.1', season, source: source ); end
def self.write_no1( season, source: ) write( 'no.1', season, source: source ); end
def self.write_se1( season, source: ) write( 'se.1', season, source: source ); end
def self.write_se2( season, source: ) write( 'se.2', season, source: source ); end
def self.write_fi1( season, source: ) write( 'fi.1', season, source: source ); end

def self.write_pl1( season, source: ) write( 'pl.1', season, source: source ); end
def self.write_cz1( season, source: ) write( 'cz.1', season, source: source ); end
def self.write_sk1( season, source: ) write( 'sk.1', season, source: source ); end

def self.write_hr1( season, source: ) write( 'hr.1', season, source: source ); end

def self.write_ua1( season, source: ) write( 'ua.1', season, source: source ); end


end   # module Writer
