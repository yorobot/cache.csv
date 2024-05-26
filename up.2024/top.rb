
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-catalogs/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-readers/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-sync/lib' )
$LOAD_PATH.unshift( '../../../sportdb/sport.db/sportdb-models/lib' )
require 'sportdb/structs'   # incl. CsvMatchParser
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"




## more libs / gems


########
# helper
#   normalize team names
  def normalize( matches, league: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lowwer first)
      res =   l.date <=> r.date
      res =   l.time <=> r.time     if res == 0 && l.time && r.time
      res =   l.round <=> r.round   if res == 0
      res
    end


    league = SportDb::Import.catalog.leagues.find!( league )
    country = league.country

    stats = {}

    ## todo/fix: cache name lookups - why? why not?
    puts "   normalize #{matches.size} matches..."
    matches.each_with_index do |match,i|        
       team1 = SportDb::Import.catalog.clubs.find_by!( name: match.team1,
                                                       country: country )
       team2 = SportDb::Import.catalog.clubs.find_by!( name: match.team2,
                                                       country: country )

       if match.team1 != team1.name
          stat = stats[ match.team1 ] ||= Hash.new(0)
          stat[ team1.name ] += 1
       end   

       if match.team2 != team2.name
          stat = stats[ match.team2 ] ||= Hash.new(0)
          stat[ team2.name ] += 1
       end
   
       match.update( team1: team1.name )
       match.update( team2: team2.name )
    end
   
    if stats.size > 0
      pp stats
    end

    print "norm OK\n"

    matches
  end




$LOAD_PATH.unshift( '../../sport.db.more/sportdb-writers/lib' )
require 'sportdb/writers'


DATASETS = [
  ['eng.2',   %w[2023/24 2022/23 2021/22 2020/21]],
]


=begin
DATASETS = [
  ['eng.1',   %w[2023/24]],

  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],
]
=end

pp DATASETS


## todo/check: find a better name for helper?
def find_repos( datasets )
  repos = []
  datasets.each do |dataset|
    league_key = dataset[0]
    league = Writer::LEAGUES[ league_key ]
    puts "==> #{league_key}:"
    pp league
    path = league[:path]

    ## use only first part e.g. europe/belgium => europe
    repos << path.split( %r{[/\\]})[0]
  end
  pp repos
  repos.uniq   ## note: remove duplicates (e.g. europe or world or such)
end



########################
#  push & pull github scripts
require 'gitti'

def git_fast_forward_if_clean( names )
  names.each do |name|
    path = "/sports/openfootball/#{name}"

    puts "==> #{name} - (#{path})..."
    Gitti::GitProject.open( path ) do |proj|
      output = proj.changes
      unless  output.empty?
        puts "FAIL - cannot git pull (fast-forward) - working tree has changes:"
        puts output
        exit 1
      end

      proj.fast_forward
   end
  end
end

## todo/fix: rename to something like
##    git_(auto_)commit_and_push_if_changes/if_dirty()

def git_push_if_changes( names )   ## optenfootball repo names e.g. world, england, etc.
  # message = "auto-update week #{Date.today.cweek}"
  message = "up week #{Date.today.cweek}"
  puts message

  names.each do |name|
    path = "/sports/openfootball/#{name}"

    Gitti::GitProject.open( path ) do |proj|
      puts ''
      puts "###########################################"
      puts "## trying to commit & push repo in path >#{path}<"
      puts "Dir.getwd: #{Dir.getwd}"
      output = proj.changes
      if output.empty?
        puts "no changes found; skipping commit & push"
      else
        proj.add( '.' )
        proj.commit( message )
        proj.push
      end
    end
  end
end




repos  = find_repos( DATASETS )
pp repos


OPTS = {
  # push: true
}


## always pull before push!! (use fast_forward)
git_fast_forward_if_clean( repos )  if OPTS[:push]


outdir = if OPTS[:push]
             "/sports/openfootball"
         else
             "./tmp"
         end

source_dir = '../../../stage'


datasets = DATASETS
datasets.each_with_index do |(league_key, seasons),i|
 
  league = Writer::LEAGUES[ league_key ]
 
  seasons.each_with_index do |season,j|
    season = Season( season )   ## convert to Season obj

    lang     = league[:lang] || 'en'
    path     = league[:path]
  
    ## note: basename && name might be dynamic, that is, procs!!! (pass in season)
    basename =  league[:basename]
    basename =  basename.call( season )  if basename.is_a?(Proc)
    name     =  league[:name] 
    name     =  name.call( season )      if name.is_a?(Proc)
  
    matches = SportDb::CsvMatchParser.read( 
                 "#{source_dir}/#{season.to_path}/#{league_key}.csv" )

    puts "==> [#{i+1}/#{datasets.size}]  #{name} #{season.key} [#{j+1}/#{seasons.size}]  -  #{matches.size} match(es)..."

    # puts
    # pp matches[0]
    # puts
    # pp matches[-1]
             
    matches = normalize( matches, league: league_key )
           
    outpath = "#{outdir}/#{path}/#{season.to_path}/#{basename}.txt"
    puts "   writing to #{outpath}"
    puts "      name: #{name} #{season.key}"
    puts "      lang: #{lang}"
    SportDb::TxtMatchWriter.write( outpath, 
                                   matches,
                                   name: "#{name} #{season.key}",
                                   lang:  lang ) 
  end
end



## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
git_push_if_changes( repos )    if OPTS[:push]


puts "bye"

