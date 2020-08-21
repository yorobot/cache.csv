########################
# Austria

LEAGUES.merge!(

  ### todo/fix:  make bundesliga pre 2017/18 use "standard" simple foramt (no stages)
  'at.1' => { name:     'Österr. Bundesliga',
              basename: '1-bundesliga',
              path:     'austria',
              lang:     'de_AT',
              stages:  [['Grunddurchgang'],
                        ['Finaldurchgang - Meister',
                         'Finaldurchgang - Qualifikation',
                         'Europa League Play-off']],
            },
  'at.2' => { name:     ->(season) { season.start_year >= 2018 ? 'Österr. 2. Liga' : 'Österr. Erste Liga' },
              basename: ->(season) { season.start_year >= 2018 ? '2-liga2' : '2-liga1' },
              path:     'austria',
              lang:     'de_AT',
            },
  'at.cup' => { name:     'ÖFB Cup',
                basename: 'cup',
                path:     'austria',
                lang:     'de_AT',
              }
)



def write_at(  season, source: 'two', split: false, normalize: true )
  ## todo use **args, **kwargs!!! to "forward args
  write_worker( 'at.1', season, source: source, split: split, normalize: normalize )
end

def write_at2( season, source: 'two', split: false, normalize: true )
  write_worker( 'at.2', season, source: source, split: split, normalize: normalize )
end

def write_at_cup( season, source: 'two', split: false, normalize: true )
  write_worker( 'at.cup', season, source: source, split: split, normalize: normalize )
end

