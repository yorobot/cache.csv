require_relative '../boot'


require_relative './leagues'


SOURCES = {
  'one'      =>  { path: '../../stage/one' },
  'one/o'    =>  { path: '../apis/o' },     ## "o" debug version

  'two'     =>  { path: '../../stage/two' },
  'two/o'   =>  { path: '../more/o' },      ## "o"   debug version
  'two/tmp' =>  { path: '../more/tmp' },    ## "tmp" debug version

  'leagues'   =>  { path: '../../../footballcsv/cache.leagues' },
  'leagues/o' =>  { path: '../cache.leagues/o' },    ## "o"  debug version

  'soccerdata' => { path:   '../../../footballcsv/cache.soccerdata',
                    format: 'century', # e.g. 1800s/1888-89
                  }
}



########
# helpers
#   normalize team names
def normalize( matches, league:, season: nil )
    league = SportDb::Import.catalog.leagues.find!( league )
    country = league.country

    ## todo/fix: cache name lookups - why? why not?
    matches.each do |match|
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       if season
         team1_name = team1.name_by_season( season )
         team2_name = team2.name_by_season( season )
       else
         team1_name = team1.name
         team2_name = team2.name
       end

       puts "#{match.team1} => #{team1_name}"  if match.team1 != team1_name
       puts "#{match.team2} => #{team2_name}"  if match.team2 != team2_name

       match.update( team1: team1_name )
       match.update( team2: team2_name )
    end
    matches
end




def split_matches( matches, season: )
  matches_i  = []
  matches_ii = []
  matches.each do |match|
    date = Date.strptime( match.date, '%Y-%m-%d' )
    if date.year == season.start_year
      matches_i << match
    elsif date.year == season.end_year
      matches_ii << match
    else
      puts "!! ERROR: match date-out-of-range for season:"
      pp season
      pp date
      pp match
      exit 1
    end
  end
  [matches_i, matches_ii]
end



def write_buf( path, buf )  ## write buffer helper
  ## for convenience - make sure parent folders/directories exist
  FileUtils.mkdir_p( File.dirname( path ))  unless Dir.exist?( File.dirname( path ))

  File.open( path, 'w:utf-8' ) do |f|
    f.write( buf )
  end
end


def write_worker( league, season, source:,
                                  extra: nil,
                                  split: false,
                                  normalize: true,
                                  rounds: true )
  season = SportDb::Import::Season.new( season )  ## normalize season

  league_info = LEAGUES[ league ]
  if league_info.nil?
    puts "!! ERROR - no league found for >#{league}<; sorry"
    exit 1
  end


  source_info = SOURCES[ source ]
  if source_info.nil?
    puts "!! ERROR - no source found for >#{source}<; sorry"
    exit 1
  end

  source_path = source_info[:path]

  ## format lets you specify directory layout
  ##   default   = 1888-89
  ##   century   = 1800s/1888-89
  ##   ...
  season_path = season.to_path( (source_info[:format] || 'default').to_sym )
  in_path = "#{source_path}/#{season_path}/#{league}.csv"   # e.g. ../stage/one/2020/br.1.csv



  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"


  ## always (auto-) sort for now - why? why not?
  matches = matches.sort do |l,r|
    ## first by date (older first)
    ## next by matchday (lower first)
    res =   l.date <=> r.date
    res =   l.round <=> r.round   if rounds && res == 0
    res
  end

  matches = normalize( matches, league: league, season: season )   if normalize

  league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
  basename     = league_info[ :basename]   #.e.g  1-seriea

  league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
  basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season

  repo_path    = league_info[ :path ]      # e.g. brazil or world/europe/portugal etc.

  season_path = String.new('')    ## note: allow extra path for output!!!! e.g. archive/2000s etc.
  season_path << "#{extra}/"   if extra
  season_path << season.path


  if split
    matches_i, matches_ii = split_matches( matches, season: season )

    # out_path = "../../../openfootball/#{repo_path}/#{season_path}/#{basename}-i.txt"
    out_path = "./o/#{repo_path}/#{season_path}/#{basename}-i.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_i,
                                   name: "#{league_name} #{season.key}",
                                   lang:  league_info[ :lang ],
                                   rounds: rounds )

    # out_path = "../../../openfootball/#{repo_path}/#{season_path}/#{basename}-ii.txt"
    out_path = "./o/#{repo_path}/#{season_path}/#{basename}-ii.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_ii,
                                   name: "#{league_name} #{season.key}",
                                   lang:  league_info[ :lang ],
                                   rounds: rounds )
  else
    # out_path = "../../../openfootball/#{repo_path}/#{season_path}/#{basename}.txt"
    out_path = "./o/#{repo_path}/#{season_path}/#{basename}.txt"

    SportDb::TxtMatchWriter.write( out_path, matches,
                                   name: "#{league_name} #{season.key}",
                                   lang:  league_info[ :lang],
                                   rounds: rounds )
  end
end


def prepare_stages( stages )
  if stages.is_a?( Array )
     if stages[0].is_a?( Array )  ## is array of array
       ## convert inner array shortcuts to hash - stage input is same as stage output
       stages.map {|ary| ary.reduce({}) {|h,stage| h[stage]=stage; h }}
     elsif stages[0].is_a?( Hash )  ## assume array of hashes
       stages  ## pass through as is ("canonical") format!!!
     else ## assume array of strings
      ## assume single array shortcut; convert to hash - stage input is same as stage output name
      stages = stages.reduce({}) {|h,stage| h[stage]=stage; h }
      [stages]  ## return hash wrapped in array
     end
  else  ## assume (single) hash
    [stages] ## always return array of hashes
  end
end

def build_stage( matches_by_stage, stages:, name:, lang: )
  buf = String.new('')

  stages.each_with_index do |(stage_in, stage_out),i|
    matches = matches_by_stage[ stage_in ]   ## todo/fix: report error if no matches found!!!

    next if matches.nil? || matches.empty?

    ## (auto-)sort matches by
    ##  1) date
    matches = matches.sort do |l,r|
      result = l.date  <=> r.date
      result
    end

    buf << "\n\n"   if i > 0

    buf << "= #{name}, #{stage_out}\n"
    buf << SportDb::TxtMatchWriter.build( matches, lang: lang )

    puts buf
  end

  buf
end


def write_worker_with_stages( league, season, stages:, source:, normalize: true )
  season = SportDb::Import::Season.new( season )  ## normalize season

  league_info = LEAGUES[ league ]

  source_info = SOURCES[ source ]
  source_path = source_info[:path]

  in_path = "#{source_path}/#{season.path}/#{league}.csv"

  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"


  matches = normalize( matches, league: league )   if normalize

  league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
  basename     = league_info[ :basename]   #.e.g  1-seriea
  lang         = league_info[ :lang ]
  repo_path    = league_info[ :path ]      # e.g. brazil or world/europe/portugal etc.

  league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
  basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season


  ## split into four stages / two files
  ## - Grunddurchgang
  ## - Finaldurchgang - Meister
  ## - Finaldurchgang - Qualifikation
  ## - Europa League Play-off

  matches_by_stage = matches.group_by { |match| match.stage }
  pp matches_by_stage.keys


  # out_dir = './tmp'
  # out_dir = "../../../openfootball/#{repo_path}"
  out_dir = "./o/#{repo_path}"


  stages = prepare_stages( stages )
  pp stages


  if stages.size == 1
    buf = build_stage( matches_by_stage, stages: stages[0],
                                         name: "#{league_name} #{season.key}",
                                         lang: lang )
    write_buf( "#{out_dir}/#{season.path}/#{basename}.txt", buf )
  elsif stages.size == 2
    buf = build_stage( matches_by_stage, stages: stages[0],
                                         name: "#{league_name} #{season.key}",
                                         lang: lang )
    write_buf( "#{out_dir}/#{season.path}/#{basename}-i.txt", buf )

    buf = build_stage( matches_by_stage, stages: stages[1],
                                         name: "#{league_name} #{season.key}",
                                         lang: lang )

    ## note: might be empty!!! if no matches skip (do NOT write)
    write_buf( "#{out_dir}/#{season.path}/#{basename}-ii.txt", buf )   unless buf.empty?
  else
    puts "!!! ERROR - too many (#{stages.size}) stage pages - for now only one or two possible; sorry:"
    pp stages
    exit 1
  end
end



def write_br( season, source: 'one' )     write_worker( 'br.1', season, source: source ); end
def write_ar( season, source: 'leagues' ) write_worker( 'ar.1', season, source: source ); end

def write_nl( season, source: 'one' )   write_worker( 'nl.1', season, source: source ); end

def write_hu( season, source: 'leagues' )   write_worker( 'hu.1', season, source: source ); end
def write_gr( season, source: 'leagues' )   write_worker( 'gr.1', season, source: source ); end

def write_pt( season, source: 'one' )   write_worker( 'pt.1', season, source: source ); end

def write_cn( season, source: 'leagues' )  write_worker( 'cn.1', season, source: source ); end
def write_jp( season, source: 'leagues' )  write_worker( 'jp.1', season, source: source ); end

def write_ru(  season, source: 'two' )  write_worker( 'ru.1', season, source: source ); end
def write_ru2( season, source: 'two' )  write_worker( 'ru.2', season, source: source ); end

def write_ch(  season, source: 'two' )  write_worker( 'ch.1', season, source: source ); end
def write_ch2( season, source: 'two' )  write_worker( 'ch.2', season, source: source ); end

def write_tr(  season, source: 'two' )  write_worker( 'tr.1', season, source: source ); end
def write_tr2( season, source: 'two' )  write_worker( 'tr.2', season, source: source ); end

def write_it(  season, source: 'one' )  write_worker( 'it.1', season, source: source ); end
def write_it2( season, source: 'two' )  write_worker( 'it.2', season, source: source ); end

def write_fr(  season, source: 'leagues' )  write_worker( 'fr.1', season, source: source ); end
def write_fr2( season, source: 'two' )      write_worker( 'fr.2', season, source: source ); end

def write_es(  season, source: 'one' )      write_worker( 'es.1', season, source: source ); end
def write_es2( season, source: 'two' )      write_worker( 'es.2', season, source: source ); end



