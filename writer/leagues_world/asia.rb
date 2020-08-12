
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


def write_cn( season, source: ) write_worker( 'cn.1', season, source: source ); end
def write_jp( season, source: ) write_worker( 'jp.1', season, source: source ); end
