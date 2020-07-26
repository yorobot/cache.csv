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
         name: name,
         round: 'Round',
         lang: 'en')
  buf
end



def write_buf( path, buf )  ## write buffer helper
  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( buf )
  end
end


def write_cz1( season )
  season = SportDb::Import::Season.new( season )  ## normalize season

  in_path = "../cache.leagues/o/#{season.path}/cz.1.csv"
  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"

  matches = normalize( matches, league: 'cz.1' )

  ## split into four stages / two files
  ## - Regular Season
  ## - Playoffs - Championship
  ## - Europa League Play-off
  ## - Playoffs - Relegation


  stages = matches.group_by { |match| match.stage }
  pp stages.keys


  # out_dir = './tmp'
  out_dir = '../../../openfootball/world/europe/czech-republic'


  league_name = 'Czech First League'


  buf = build_stage( stages['Regular Season'],
                     name: "#{league_name} #{season.key}, Regular Season" )
  puts buf
  write_buf( "#{out_dir}/#{season.path}/1-firstleague-i.txt", buf )
  puts "-----------"


  buf = String.new('')
  buf << build_stage( stages['Playoffs - Championship'],
                      name: "#{league_name} #{season.key}, Playoffs - Championship" )
  puts buf
  puts "-----------"

  buf << "\n\n"
  buf << build_stage( stages['Europa League Play-off'],
                      name: "#{league_name} #{season.key}, Europa League Play-off" )
  puts buf
  puts "-----------"

  buf << "\n\n"
  buf << build_stage( stages['Playoffs - Relegation'],
                      name: "#{league_name} #{season.key}, Playoffs - Relegation" )
  puts buf

  write_buf( "#{out_dir}/#{season.path}/1-firstleague-ii.txt", buf )
end



write_cz1( '2018/19' )

puts "bye"


