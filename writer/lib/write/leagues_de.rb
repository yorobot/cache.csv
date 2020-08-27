module Writer

############################
# Germany / Deutschland

LEAGUES.merge!(
  'de.1' => { name:     'Deutsche Bundesliga',
              basename: '1-bundesliga',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.2' => { name:     'Deutsche 2. Bundesliga',
              basename: '2-bundesliga2',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.3' => { name:     'Deutsche 3. Liga',
              basename: '3-liga3',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.cup' => { name:     'DFB Pokal',
                basename: 'cup',
                path:     'deutschland',
                lang:     'de_DE',
              }
)

def self.write_de1(   season, source: 'leagues', extra: nil, split: false, normalize: true )
  write( 'de.1', season, source: source, extra: extra, split: split, normalize: normalize )
end

def self.write_de2(  season, source: 'leagues', extra: nil, split: false, normalize: true )
  write( 'de.2', season, source: source, extra: extra, split: split, normalize: normalize )
end

def self.write_de3(  season, source: 'leagues', extra: nil, split: false, normalize: true )
  write( 'de.3', season, source: source, extra: extra, split: split, normalize: normalize )
end

def self.write_de_cup(  season, source: 'two', split: false, normalize: true )
  write( 'de.cup', season, source: source, split: split, normalize: normalize )
end


end   # module Writer
