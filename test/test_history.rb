require_relative '../boot'


CLUBS         = SportDb::Import.catalog.clubs
CLUBS_HISTORY = SportDb::Import.catalog.clubs_history
pp CLUBS_HISTORY.mappings


puts CLUBS_HISTORY.find_name_by( name: 'WSG Tirol', season: '2019/20' )
puts CLUBS_HISTORY.find_name_by( name: 'WSG Tirol', season: '2018/9' )
puts CLUBS_HISTORY.find_name_by( name: 'WSG Tirol', season: '2017/8' )


club = CLUBS.find( 'WSG Wattens' )
pp club

puts club.name_by_season( '2019/20' )
puts club.name_by_season( '2018/9' )
puts club.name_by_season( '2017/8' )


club = CLUBS.find( 'Rapid Wien' )
pp club

puts club.name_by_season( '2000/1' )
puts club.name_by_season( '1891/2' )


club = CLUBS.find_by( name: 'Arsenal', country: 'ENG' )
pp club

puts club.name_by_season( '2000/1' )
puts club.name_by_season( '1927/8' )
puts club.name_by_season( '1926/7' )
puts club.name_by_season( '1913/4' )
puts club.name_by_season( '1891/2' )


