####################
# England

LEAGUES.merge(
  'eng.1' => { name:     'English Premier League',
               basename: '1-premierleague',
               path:     'england',
               lang:     'en',
             },
  'eng.2' => { name:     'English Championship',
               basename: '2-championship',
               path:     'england',
               lang:     'en',
             },
  'eng.3' => { name:     'English League One',
               basename: '3-league1',
               path:     'england',
               lang:     'en',
             },
  'eng.4' => { name:     'English League Two',
               basename: '4-league2',
               path:     'england',
               lang:     'en',
             },
  'eng.5' => { name:     'English National League',
               basename: '5-nationalleague',
               path:     'england',
               lang:     'en',
           },
  'eng.cup' => { name:  'English FA Cup',
                 basename: 'facup',
                 path:     'england',
                 lang:     'en',
               }
)


def write_eng(  season, source: 'one', extra: nil )
  write_worker( 'eng.1', season, source: source, extra: extra )
end

def write_eng2( season, source: 'one', extra: nil )
  write_worker( 'eng.2', season, source: source, extra: extra )
end

def write_eng3( season, source: 'two', extra: nil )
  write_worker( 'eng.3', season, source: source, extra: extra )
end

def write_eng4( season, source: 'two', extra: nil )
  write_worker( 'eng.4', season, source: source, extra: extra )
end

def write_eng5( season, source: 'two' )
  write_worker( 'eng.5', season, source: source )
end

def write_eng_cup( season, source: 'two' )
  write_worker( 'eng.cup', season, source: source )
end


