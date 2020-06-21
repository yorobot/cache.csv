require_relative 'boot'



EVENTS  = SportDb::Import::EventIndex.build( "../../../openfootball/leagues" )
SEASONS = SportDb::Import::SeasonIndex.new( EVENTS )



if __FILE__ == $0
  pp SEASONS.find_by( date: Date.new( 2018, 5, 4 ),  league: 'br.1' )
  pp SEASONS.find_by( date: Date.today,              league: 'br.1' )

  pp SEASONS.find_by( date: Date.new( 2018, 5, 4 ),  league: 'ar.1' )
  pp SEASONS.find_by( date: Date.new( 2020, 3, 9 ),  league: 'ar.1' )

  pp SEASONS.find_by( date: Date.new( 2014, 5, 24),  league: 'ar.1' )
  pp SEASONS.find_by( date: Date.new( 2014, 8, 8),   league: 'ar.1' )

  pp SEASONS.find_by( date: '2014-05-24', league: 'ar.1' )
  pp SEASONS.find_by( date: '2014-08-08', league: 'ar.1' )

  pp EVENTS.find_by( league: 'ar.1', season: '2014' )
  pp EVENTS.find_by( league: 'ar.1', season: '2013/14' )
  pp EVENTS.find_by( league: 'ar.1', season: '2021' )

  puts "bye"
end

