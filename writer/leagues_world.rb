
LEAGUES.merge!(
  'ar.1' => { name:     'Argentina Primera Division',
              basename: '1-primeradivision',
              path:     'world/south-america/argentina',
              lang:     'es_AR',
            },

  'cn.1' => { name:     'Chinese Super League',
              basename: '1-superleague',
              path:     'world/asia/china',
              lang:     'en',   ## note: use english for now
            },
  'jp.1' => { name:     'Japan J1 League',
            basename: '1-j1league',
            path:     'world/asia/japan',
            lang:     'en',   ## note: use english for now
          },

  'hu.1' => { name:     'Hungarian NB I',
              basename: '1-nbi',
              path:     'world/europe/hungary',
              lang:     'en',   ## note: use english for now
            },
  'gr.1' => { name:     'Super League Greece',
              basename: '1-superleague',
              path:     'world/europe/greece',
              lang:     'en',   ## note: use english for now
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
              lang:     'en',   ## note: use english for now
            },
  'tr.2' => { name:     'Turkish 1. Lig',
              basename: '2-lig1',
              path:     'world/europe/turkey',
              lang:     'en',   ## note: use english for now
            },


  'is.1' => { name:     'Iceland Urvalsdeild',
              basename: '1-urvalsdeild',
              path:     'world/europe/iceland',
              lang:     'en_AU',   ## note: use english for now
            },
  'sco.1' => { name:     'Scottish Premiership',
               basename: '1-premiership',
               path:     'world/europe/scotland',
               lang:     'en_AU',  ## uses round (and not matchday as default)
             },
  'ie.1' => { name:     'Irish Premier Division',
              basename: '1-premierdivision',
              path:     'world/europe/ireland',
              lang:     'en_AU',   ## note: use english for now
            },

  'fi.1' => { name:     'Finland Veikkausliiga',
              basename: '1-veikkausliiga',
              path:     'world/europe/finland',
              lang:     'en_AU',   ## note: use english for now
            },
 'se.1'  => { name:     'Sweden Allsvenskan',
                basename: '1-allsvenskan',
                path:     'world/europe/sweden',
                lang:     'en_AU',   ## note: use english for now
              },
   'se.2'  => { name:     'Sweden Superettan',
                basename: '2-superettan',
                path:     'world/europe/sweden',
                lang:     'en_AU',   ## note: use english for now
              },
   'no.1'  => { name:     'Norwegian Eliteserien',
                basename: '1-eliteserien',
                path:     'world/europe/norway',
                lang:     'en_AU',   ## note: use english for now
              },
   'dk.1'  => { name:     'Denmark Superligaen',
                basename: '1-superligaen',
                path:     'world/europe/denmark',
                lang:     'en_AU',   ## note: use english for now
              },

   'lu.1'  => { name:     'Luxembourger First Division',
                basename: '1-nationaldivision',
                path:     'world/europe/luxembourg',
                lang:     'en_AU',   ## note: use english for now
              },
   'be.1'  => { name:     'Belgian First Division A',
                basename: '1-firstdivisiona',
                path:     'world/europe/belgium',
                lang:     'en_AU',  ## uses round (and not matchday as default)
               },
    'nl.1' =>  { name:     'Dutch Eredivisie',
                 basename: '1-eredivisie',
                 path:     'world/europe/netherlands',
                 lang:     'en_AU',  ## uses round (and not matchday as default)
               },

  'sk.1' =>   { name:     'Slovakia First League',
                basename: '1-superliga',
                path:     'world/europe/slovakia',
                lang:     'en_AU',   ## note: use english for now
              },
  'hr.1'  =>  { name:     'Croatia 1. HNL',
                basename: '1-hnl',
                path:     'world/europe/croatia',
                lang:     'en_AU',   ## note: use english for now
              },
  'pl.1' => { name:     'Poland Ekstraklasa',
              basename: '1-ekstraklasa',
              path:     'world/europe/poland',
              lang:     'en_AU',   ## note: use english for now
            },

  'ua.1' => { name:     'Ukraine Premier League',
              basename: '1-premierleague',
              path:     'world/europe/ukraine',
              lang:     'en_AU',   ## note: use english for now
            },

)



def write_is( season, source: )  write_worker( 'is.1', season, source: source ); end
def write_se( season, source: )  write_worker( 'se.1', season, source: source ); end
def write_se2( season, source: ) write_worker( 'se.2', season, source: source ); end
def write_no( season, source: )  write_worker( 'no.1', season, source: source ); end

def write_lu( season, source: )  write_worker( 'lu.1', season, source: source ); end
def write_nl( season, source: )  write_worker( 'nl.1', season, source: source ); end

def write_hr( season, source: )  write_worker( 'hr.1', season, source: source ); end

def write_ie( season, source: )  write_worker( 'ie.1', season, source: source ); end


STAGES_SCO = [['Regular Season'],
              ['Playoffs - Championship',
               'Playoffs - Relegation' ]]

def write_sco( season, source: )
  write_worker_with_stages( 'sco.1', season, source: source, stages: STAGES_SCO )
end


STAGES_FI = [['Regular Season'],
             ['Playoffs - Championship',
              'Playoffs - Challenger',
              'Europa League Finals' ]]

def write_fi( season, source: )
  write_worker_with_stages( 'fi.1', season, source: source, stages: STAGES_FI )
end

STAGES_DK = [['Regular Season'],
             ['Playoffs - Championship',
              'Playoffs - Relegation',
              'Europa League Finals']]

def write_dk( season, source: )
  write_worker_with_stages( 'dk.1', season, source: source, stages: STAGES_DK )
end

STAGES_PL = [['Regular Season'],
             ['Playoffs - Championship',
              'Playoffs - Relegation']]

def write_pl( season, source: )
  write_worker_with_stages( 'pl.1', season, source: source, stages: STAGES_PL )
end

STAGES_SK = [['Regular Season'],
             ['Playoffs - Championship',
             'Playoffs - Relegation',
             'Europa League Finals']]

def write_sk( season, source: )
  write_worker_with_stages( 'sk.1', season, source: source, stages: STAGES_SK )
end


STAGES_UA = [['Regular Season'],
             ['Playoffs - Championship',
              'Playoffs - Relegation',
              'Europa League Finals']]

def write_ua( season, source: )
  write_worker_with_stages( 'ua.1', season, source: source, stages: STAGES_UA )
end



STAGES_BE = [['Regular Season'],
             ['Playoffs - Championship',
              'Playoffs - Europa League',
              'Playoffs - Europa League - Finals' ]]

def write_be( season, source: )
  write_worker_with_stages( 'be.1', season, source: source, stages: STAGES_BE )
end

