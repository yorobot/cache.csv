## hack: use "local" dev monoscript too :-) for now
$LOAD_PATH.unshift( 'C:/Sites/yorobot/cache.csv/monos/lib' )

## note: use the local version of sportdb-source gem
require 'mono'

# h = YAML.load_file( './repos.yml' )
# Mono.sync( h )
# Mono.sync
Mono::Tool.main( ['sync'] )



