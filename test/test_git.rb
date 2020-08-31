## hack: use "local" dev monoscript too :-) for now
$LOAD_PATH.unshift( 'C:/Sites/yorobot/cache.csv/monoscript/lib' )

require 'mono'


puts Git.version
puts Git.changes
puts Git.clean?
puts Git.changes?
puts Git.dirty?


