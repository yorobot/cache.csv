##
# todos/fix
#
#   date format add  "-" for empty!!
#    ! WARN - no date of birth (or wrong format)
#    e.g "Date of Birth"=>"-",
#
#   add date format - year (with single digit) 
#    e.g.  "Date of Birth"=>"25-08-5", or
#   
#  name lookup
#    for fr.1 - add  monaco !!
#    for 


require_relative 'helper'   ## (shared) boot helper


SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"






## pos sort order
POS = {
    'G'  => 1,
    'D'  => 2,
    'M'  => 3,
    'F'  => 4
}

## pretty print (pp) pos
# 
# GK  or  G
# DF or   D
# MF or   M
# FW or   F

PPPOS = {
    'G'  => 'GK',  # goal keeper
    'D'  => 'DF',  # defence
    'M'  => 'MF',  # mid fielder
    'F'  => 'FW',  # forward
}


def sort_players( data )
    data.sort do |l,r|
       res = (POS[ l['Pos']] || 99)  <=> ((POS[ r['Pos']] || 99))
       res =  l['Number'].to_i(10)   <=>  r['Number'].to_i(10)  if res == 0
       res
    end
end

def pp_players( data )
    buf = ""
    last_rec = nil
    data.each do |rec|
         ## auto-add separator if starting new pos (e.g. G/D/M/F/??)
         buf << "\n" if last_rec && last_rec['Pos'] != rec['Pos']

         buf << pp_player( rec )
         buf << "\n"
         last_rec = rec
    end
    buf
end

def pp_player( rec )
    buf = ""
    buf << '%2s  ' % rec['Number']
    buf << '%-28s   ' % "#{rec['Name']} (#{rec['Nat']})"
    buf << '%-2s' % PPPOS[rec['Pos']] || "??#{rec['Pos']}"
    buf << "   "

    dob_str = rec['Date of Birth']

  ## fix for  Mike Penders (BEL)
  if rec['Name'] == 'Mike Penders' && rec['Nat'] == 'BEL'
     ## "Date of Birth"=>"31-06-05",
     dob_str = '31-07-05'  #  is July (not June) - June 31st does NOT exist!!  
  end

    ## note: MUST parse by our own (in ruby year 65 => 2065)
    ## 24-06-99
    ## assert date format
    dob = if dob_str.match( /^\d{2}-\d{2}-\d{2}$/ )
            dob_i = dob_str.split( '-').map { |str| str.strip.to_i(10) }
            begin
              Date.new( dob_i[2] < 20 ? 2000+dob_i[2] : 1900+dob_i[2],
                      dob_i[1],
                      dob_i[0] )
            rescue => ex
              puts "! WARN - error date of birth:"
              pp ex
              pp dob_str
              pp rec
              nil            
            end
          else
              puts "! WARN - no date of birth (or wrong format):"
              pp dob_str
              pp rec
              nil
          end    
          
    buf2 = ""    
    if dob  
      buf2 << "#{dob.strftime( '%d %b %Y' )}"
      buf2 << ", #{rec['Birth Place']}"  if rec['Birth Place'].size > 0 &&
                                           rec['Birth Place'] != '-'
    end 
    buf2 << "  -- #{rec['Previous Club']}"  if rec['Previous Club'].size > 0 &&
                                                rec['Previous Club'] != 'None' 

    ## add comments if available (non-empty only)                                            
    buf << " # #{buf2.strip}"     if buf2.size > 0                                            
    buf
end


def convert_league(  outdir:,
                     league:,
                     season: )
                     
league_page = Footballsquads.league( league: league, season: season )
pp league_page.title

## find league rec
leagues = SportDb::Import.catalog.leagues
league_rec   = leagues.find!( league )


league_page.each_team do |team_page|
   # pp team_page.title

   team_name         =  team_page.team_name
   # pp team_name
   team_name_official = team_page.team_name_official
   # pp team_name_official

##
#  map team name
#  
    # try short name first
    clubs =  SportDb::Import.catalog.clubs

    m1 = clubs.match_by( name: team_name,           country: league_rec.country.key )
    m2 = clubs.match_by( name: team_name_official,  country: league_rec.country.key )

   team_name_short =  
    if m1.size == 1 && m2.size == 1
       puts "OK  #{team_name}  -  #{team_name_official}  =>  #{m1[0].name}"

       m1[0].name   ## use "canonical name"
    else
      ## report 
      if m1.size == 0 && m2.size == 0
        puts
        puts "!!  no match for team in  #{league_rec.country.name} - #{league_rec.name}:"
        puts "    #{team_name}"
        puts "    #{team_name_official}"
     else
        puts "!!  missing match for team in  #{league_rec.country.name} - #{league_rec.name}:"
        if m1.size == 0
            puts "   !!  #{team_name}"
        elsif m1.size == 1
            puts "   OK  #{team_name}"
        else
            puts "   !!  #{team_name}  - too many matches - #{m1.size}:"
            pp m1
        end
        if m2.size == 0
          puts "   !!  #{team_name_official}"
        elsif m2.size == 1
          puts "   OK  #{team_name_official}"
        else
          puts "   !!  #{team_name_official}  - too many matches - #{m2.size}:"
          pp m2
        end

        ## use org name  with official name as comment
        ##   -- log warning!! to errors.txt or logs.txt or such!!!
        "#{team_name_official}    # #{team_name}"
    end
  end

  current, past =  team_page.players

   # puts "current (#{current.size}):"
   # pp current
   # puts "past (#{past.size}):"
   # pp past  
   
   ## e.g. Brighton & Hove Albion => brighton_hove_albion
   slug = unaccent( team_name ).downcase.gsub( /[^a-z0-9 ]/, '').gsub( /[ ]+/, '_' )
   season_slug = Season( season ).to_path
   path = "#{outdir}/#{season_slug}/squads/#{slug}.txt"

## note - use official (long) team name - add (short) team name as comment   
buf = ""
buf << "= #{team_name_short}\n\n"
buf << pp_players( sort_players(current))
   
write_text( path, buf )
end
end  # method convert_league









DATASETS_TOP = [
  ['eng.1',   %w[2023/24]],
  ['de.1',    %w[2023/24]],
  ['es.1',    %w[2023/24]],
  ['fr.1',    %w[2023/24]],
  ['it.1',    %w[2023/24]],

  ['at.1',    %w[2023/24]],
]


# try some more
DATASETS_MORE = [
#  ['sco.1',  %w[2023/24]], 
#  ['pt.1',  %w[2023/24]],
#  ['nl.1',   %w[2023/24]],

 ['be.1',  %w[2023/24]],

=begin
  ['tr.1',  %w[2023/24]],
  ['gr.1',  %w[2023/24]],

  ['ru.1',  %w[2023/24]],
  ['ua.1', %w[2023/24]],
  ['pl.1',  %w[2023/24]],

  ['br.1',  %w[2024]],
  ['ar.1',  %w[2024]], 
  
  ['eng.2',   %w[2023/24]],
  ['eng.3',   %w[2023/24]],
  ['de.2',    %w[2023/24]],
  ['es.2',    %w[2023/24]],
  ['fr.2',    %w[2023/24]],
  ['it.2',    %w[2023/24]],
=end
]

pp DATASETS_TOP
pp DATASETS_MORE


# datasets = DATASETS_TOP
datasets = DATASETS_MORE

repos  = find_repos( datasets )
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


Webcache.root = '../../../cache'  ### c:\sports\cache
pp Webcache.root


datasets.each_with_index do |(league_key, seasons),i|
 
  league = Writer::LEAGUES[ league_key ]
  if league.nil?
    puts "!! ERROR - sorry no write config for league found >#{league_key}<"
    exit 1
  end
 
  seasons.each_with_index do |season_key,j|  
    season   =  Season( season_key )
    path     =  league[:path]  ## relative (git) repo path
    name     =  league[:name] 
    name     =  name.call( season )      if name.is_a?(Proc)
 
    puts "==> [#{i+1}/#{datasets.size}]  #{name} #{season_key} [#{j+1}/#{seasons.size}]..."

    convert_league( outdir: "#{outdir}/#{path}",
                    league: league_key, 
                    season: season_key )
  end
end



## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
git_push_if_changes( repos )    if OPTS[:push]


puts "bye"

