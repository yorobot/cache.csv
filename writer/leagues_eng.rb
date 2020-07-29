####################
# England



def eng1( season )
  case season
  when Season.new('1888/89')..Season.new('1891/92') ## single league (no divisions)
    {name:     'English Football League',
     basename: '1-footballleague'}
  when Season.new('1892/93')..Season.new('1991/92')  ## start of division 1 & 2
    {name:     'English Division One',
     basename: '1-division1'}
  else  ## starts in season 1992/93
    {name:     'English Premier League',
     basename: '1-premierleague'}
  end
end

def eng2( season )
  case season
  when Season.new('1892/93')..Season.new('1991/92')
    {name:     'English Division Two',  ## or use English Football League Second Division ???
     basename: '2-division2'}
  when Season.new('1992/93')..Season.new('2003/04')   ## start of premier league
    {name:     'English Division One',
     basename: '2-division1'}
  else # starts in 2004/05
    {name:     'English Championship',  ## rebranding divsion 1 => championship
     basename: '2-championship'}
  end
end


LEAGUES.merge!(
  'eng.1' => { name:     ->(season) { eng1( season )[ :name ]     },
               basename: ->(season) { eng1( season )[ :basename ] },
               path:     'england',
               lang:     'en',
             },
  'eng.2' => { name:     ->(season) { eng2( season )[ :name ]     },
               basename: ->(season) { eng2( season )[ :basename ] },
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


def write_eng1( season, **kwargs )
  kwargs[:source] ||= 'one'
  write_worker( 'eng.1', season, **kwargs )
end

def write_eng2( season, **kwargs )
  kwargs[:source] ||= 'one'
  write_worker( 'eng.2', season, **kwargs )
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


