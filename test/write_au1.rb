require_relative '../boot'



########
# helpers
#   normalize team names

def normalize( matches, league: )
  league = SportDb::Import.catalog.leagues.find!( league )
  country = league.country

  ## todo/fix: cache name lookups - why? why not?
  matches.each do |match|
     team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                     country: country )
     team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                     country: country )

     puts "#{match.team1} => #{team1.name}"  if match.team1 != team1.name
     puts "#{match.team2} => #{team2.name}"  if match.team2 != team2.name

     match.update( team1: team1.name )
     match.update( team2: team2.name )
  end
  matches
end



def build_stage( matches, name: )
  ## sort matches by
  ##  1) date

  matches = matches.sort do |l,r|
    result = l.date  <=> r.date
    result
  end

  buf = SportDb::TxtMatchWriter.build( matches,
         name:  name,
         round: 'Round',
         lang:  'en')
  buf
end



def write_buf( path, buf )  ## write buffer helper
  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( buf )
  end
end


def write_au1( season )
  season = SportDb::Import::Season.new( season )  ## normalize season

  in_path = "../cache.leagues/o/#{season.path}/au.1.csv"
  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"

  matches = normalize( matches, league: 'au.1' )

  ## split into two stages
  ## - Regular Season
  ## - Finals

  stages = matches.group_by { |match| match.stage }
  pp stages.keys


  # out_dir = './tmp'
  out_dir = '../../../openfootball/world/pacific/australia'


  league_name = 'Australian A-League'


  buf = String.new('')
  buf << build_stage( stages['Regular Season'],
                     name: "#{league_name} #{season.key}, Regular Season" )
  puts buf

  buf << "\n\n"
  buf << build_stage( stages['Finals'],
                      name: "#{league_name} #{season.key}, Finals" )
  puts buf

  write_buf( "#{out_dir}/#{season.path}/1-aleague.txt", buf )
end



write_au1( '2018/19' )

puts "bye"


