module Writer

########################
# Austria

LEAGUES.merge!(
  'at.1' => { name:     'Österr. Bundesliga',
              basename: '1-bundesliga',
              path:     'austria',
              lang:     'de_AT',
              stages:   ->(season) {
                            if season.start_year >= 2018
                             [['Grunddurchgang'],
                              ['Finaldurchgang - Meister',
                               'Finaldurchgang - Qualifikation',
                               'Europa League Play-off']]
                            else
                              nil
                            end
                          },
            },
  'at.2' => { name:     ->(season) { season.start_year >= 2018 ? 'Österr. 2. Liga' : 'Österr. Erste Liga' },
              basename: ->(season) { season.start_year >= 2018 ? '2-liga2' : '2-liga1' },
              path:     'austria',
              lang:     'de_AT',
            },
  'at.3.o' => { name:     'Österr. Regionalliga Ost',
                basename: '3-regionalliga-ost',
                path:     'austria',
                lang:     'de_AT',
              },
  'at.cup' => { name:     'ÖFB Cup',
                basename: 'cup',
                path:     'austria',
                lang:     'de_AT',
              }
)



def self.write_at1( season, source: 'two', split: false, normalize: true )
  ## todo use **args, **kwargs!!! to "forward args, see england - why? why not?
  write( 'at.1', season, source: source, split: split, normalize: normalize )
end

def self.write_at2( season, source: 'two', split: false, normalize: true )
  write( 'at.2', season, source: source, split: split, normalize: normalize )
end

def self.write_at_cup( season, source: 'two', split: false, normalize: true )
  write( 'at.cup', season, source: source, split: split, normalize: normalize )
end


end   # module Writer
