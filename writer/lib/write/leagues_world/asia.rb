module Writer

LEAGUES.merge!(
  'cn.1' => { name:     'Chinese Super League',
              basename: '1-superleague',
              path:     'world/asia/china',
            },
  'jp.1' => { name:     'Japan J1 League',
              basename: '1-j1league',
              path:     'world/asia/japan',
          },
)


def self.write_cn( season, source: ) write( 'cn.1', season, source: source ); end
def self.write_jp( season, source: ) write( 'jp.1', season, source: source ); end


end   # module Writer
