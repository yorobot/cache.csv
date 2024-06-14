##
# todos/fix
#
#  name lookup
#    for fr.1 - add  monaco !!
#    for 
#
#   for cc see ->
## Nationalities are shown using FIFA Country Codes,
#  a full list of which can be found here
#  https://www.footballsquads.co.uk/fifacodes.htm





### skip
##   players with no date of birth for now!!!
##



########
#  note: use unaccent (squish and downcase)
#         for name key to avoid duplicates e.g.
#   İlkay Gündogan,               M,  1.80 m,  b. 24 Oct 1990 @ Gelsenkirchen
#   İlkay Gündoğan,               M,  1.80 m,  b. 24 Oct 1990 @ Gelsenkirchen
#   ...
#
#  in spain
#   Fabián,                       M,  1.89 m,  b. 3 Apr 1996 @ Los Palacios y Villafranca
#   Fabián Ruiz,                  M,  1.89 m,  b. 3 Apr 1996 @ Los Palacios y Villafranca
#
#  in belgium
#   Timothy Castagne,             D,  1.80 m,  b. 5 Dec 1995 @ Aarlen
#   Timoty Castagne,              D,  1.80 m,  b. 5 Dec 1995 @ Aarlen
#   check by date of birth or such
#
#  more in brazil !!!
#   Fred,                         M,  1.69 m,  b. 5 Mar 1993 @ Belo Horizonte
#   Fred,                         F,  1.85 m,  b. 3 Oct 1983 @ Téofilo Otoni
#
#   Kaka,                         D,  - ,      b. 16 Oct 2004
#   Kaká,                         M,  1.86 m,  b. 22 Apr 1982 @ Brasília
#
#  same name but different birthdate/year !!
#   e.g. in england
#  Reece James,                  D,  1.68 m,  b. 7 Nov 1993 @ Bacup 
#  Reece James,                  D,  1.83 m,  b. 8 Dec 1999 @ Redbridge
#
#
#  track different heights too
#    for now use max (in theory young player still growing)
#
# for pos(ition) use latest (may change D to M etc)
#          or yes, allow more than one?
#              add   D|F  or M|F etc.
#
#

require_relative 'helper'   ## (shared) boot helper


SportDb::Import.config.catalog_path = '../../../sportdb/sport.db/catalog/catalog.db'

## move (for reusue) to CatalogDb::Metal.tables or such - why? 
puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"


## collect all players by country (1st nationality)
PLAYERS = {}   



## find league rec
LEAGUES   = SportDb::Import.catalog.leagues
CLUBS     = SportDb::Import.catalog.clubs
COUNTRIES = SportDb::Import.world.countries




NODATE = Date.new(1800, 1,1)

def sort_players( data )
     ## sort by 1) dob, 2) name for now
    data.sort do |l,r|

=begin      
       ###
       # assert we get not corrupt data
       unless l[:name].is_a?( String ) &&
              r[:name].is_a?( String )
            puts "!! ERROR - expected strings for player data got:"
            pp l 
            pp r
            exit 1
       end
=end
       res = (r[:dob] || NODATE ) <=> (l[:dob] || NODATE)
       ### use first name of variants for now
       res =  l[:names][0]  <=>  r[:names][0]  if res == 0
       res
    end
end


POS_SORT = {
  'G' => 1,
  'D' => 2,
  'M' => 3,
  'F' => 4
}

def pp_players( data )
     data = sort_players( data )
     buf = String.new
     last_dob = nil

     data.each do |rec| 

       ## quick & dirty heuristic for selecting name variant
       ##   works for majority (BUT not all cases)
       ##     different accents, different upcase/downcase,
       ##       name with our without dash, etc.
       ##    e.g.   Ricardo Vaz Tê  -or- Ricardo Vaz Té   ???
       ##            Nils De Wilde  -or- Nils de Wilde    ???
       ##            Hwang Hee-chan -or.  Hwang Hee-Chan ???
       ##            Ron Thorben Hoffmann  -or-  Ron-Thorben Hoffmann ???
       ## sort by bytesize (assumes)
       ##    unaccented ascii name last and accented first
       sorted_names   = rec[:names].sort { |l,r| r.bytesize <=> r.bytesize }
       name = sorted_names[0]

       ## sort by G|D|M|F
       pos       = rec[:pos].sort { |l,r| POS_SORT[l] <=> POS_SORT[r] }.join('|')
       ## fix/todo - sort height - get max value for now 
       height    = rec[:height][0]
       dob       = rec[:dob]
       dob_place = rec[:dob_place]

       ## auto-add separator if bod year changed
       buf << "\n"   if last_dob && last_dob.year != (dob||NODATE).year

       buf << "%-30s" % "#{name},"
       buf << "%-4s"  % "#{pos},"
       buf << "%-9s" % if height
                         "#{height} m,"
                       else
                         "- ,"
                       end
        if dob  
          buf << "b. #{dob.strftime( '%-d %b %Y' )}"
          buf << " @ #{dob_place}"  if dob_place
        else
          buf << "-"
        end 
      buf << "\n"
      last_dob = dob
     end
     buf
end




def add_players( data )
    data.each { |rec| add_player( rec ) }
end



def add_player( rec )
    name = rec['Name']  || rec['Namea']   ## fix upstream
    nat  = rec['Nat']
    pos  = rec['Pos']   ## keep G|D|M|F for now
    height = if rec['Height'].size > 0 && rec['Height'] != '-'
                rec['Height']
              else
                 nil
              end

    ##  fix upstream
    ##    column name with traling dash e.g.
    ##  Date of Birth-
    dob_str = rec['Date of Birth'] || 
              rec['Date of Birth-'] ||
              rec['Date o-f Birth']

    if dob_str.nil?
      puts "!! WARN - date of birth (d.o.b.) is nil - why? - skipping entry for now"
      pp rec
      return
    end


    if name.nil?
        puts "!! ERROR - name is nil - why?"
        pp rec
        exit 1
    end

    ## e.g.
    ## no. 19 in www.footballsquads.co.uk/ger/2017-2018/bundes/mainz.htm
    if name.empty?
      puts "!! WARN - name is empty - skipping entry for now"
      pp rec
      return
    end


    
    if name == 'Tony Rölke' && nat == 'GE'
       nat = 'GER'
    end
   ##  
  ##  share known bugs/auto-fixes in its own file??
  ## fix for  Mike Penders (BEL)
  if name == 'Mike Penders' && nat == 'BEL'
     ## "Date of Birth"=>"31-06-05",
     dob_str = '31-07-05'  #  is July (not June) - June 31st does NOT exist!!  
  end
  if name == 'Luca Philipp' && nat == 'GET'
     ## fix - no country code found >GET<
     nat     = 'GER'
  end
  if name == 'Jed Meerholz' && nat == 'EMG'
    ## fix - no country code found >EMG<
    nat     = 'ENG'
  end
  if name == 'Aboubakary Kanté' && nat == 'GMB'
    ## fix - no country code found >GMB<
    nat     = 'GAM'  # gambia
  end
  if name == 'Alessandro Caporale' && nat == 'IRA'
    ## fix - no country code found >IRA<
    nat     = 'ITA'  
  end
  if name == 'David García' && nat == 'ESO'
    ## fix - no country code found >ESO<
    nat     = 'ESP'  
  end
  if name == "Luke O'Regan" && nat == 'iRL'
    ## fix - no country code found >iRL<
    nat     = 'IRL'  
  end
  if name == "Nemanja Radonjić" && nat == 'SEB'
    ## fix - no country code found >SEB<
    nat     = 'SRB'  
  end
  if name == "Akmal Bakhtiyarov" && nat == 'KZK'
    ## fix - no country code found >KZK<
    nat     = 'KAZ'  
  end
  

  ## assert nat is a three letter code (not GE for example)
    unless nat.match( /^[A-Z]{3}$/ )
       puts "!! ERROR - three-letter code expected; got: #{nat}"
       pp rec
       exit 1
    end
 
    unless %w[G D M F].include?(pos)
       puts "!! ERROR - for pos G|D|M|F expected; got: #{pos}"
       pp rec
       exit 1
    end


 
    ## note: MUST parse by our own (in ruby year 65 => 2065)
    ## 24-06-99
    ## assert date format
    dob = if ['-'].include?( dob_str )    ## note: "-" used for no date 
              nil
          elsif dob_str.match( /^\d{2}-\d{2}-\d{1,2}$/ )
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

          
      ## note - for now skip all players WITHOUT birthdate
      return  if dob.nil?    
    

      dob_place = if dob  && rec['Birth Place'].size > 0 &&
                    rec['Birth Place'] != '-'
                    
                    ## change country [ARG] to (ARG)
                    rec['Birth Place'].gsub( /\[
                                                 ([A-Z]{3})
                                              \]/x,  '(\1)' )
                  else
                    nil
                  end

      ## use normalized name for key lookup
      ##       plus birth year
      key =   unaccent( name ).downcase.gsub( /[^a-z]/, '' )
      key += "_#{dob.year}"    ## add month too? why? why not?


      names = PLAYERS[ nat ] ||= {}
      rec = names[ key ] ||=  { count:     0,
                                names:     [],
                                nat:       nil,
                                pos:       [],
                                height:    [],  
                                dob:       nil,
                                dob_place: nil }
      rec[:count] += 1
      # overwrite for now fix - (check later if change)!!!!
      ##  check if name/pos/height is different
      ##   for now collect all variants
      rec[:names]    << name      unless rec[:names].include?(name)
      rec[:nat]       = nat
      rec[:pos]      << pos       unless rec[:pos].include?(pos)
      rec[:height]   << height    unless rec[:height].include?(height)
      rec[:dob]       = dob 
      rec[:dob_place] = dob_place     if dob_place   ## note - ignore variants here for now                                 
end




def add_league( league:,
                season: )
                     
league_page = Footballsquads.league( league: league, season: season )
pp league_page.title

league_rec   = LEAGUES.find!( league )

league_page.each_team do |team_page|
   # pp team_page.title

   if league_rec.club?
     team_name         =  team_page.team_name
     # pp team_name
     team_name_official = team_page.team_name_official
     # pp team_name_official
##
#  map team name
#  
    # try short name first

    m1 = CLUBS.match_by( name: team_name,           country: league_rec.country.key )
    m2 = CLUBS.match_by( name: team_name_official,  country: league_rec.country.key )

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
end


current, past =  team_page.players

   # puts "current (#{current.size}):"
   # pp current
   # puts "past (#{past.size}):"
   # pp past  
   
   add_players( current )
   add_players( past )
end
end  # method convert_league




## add three more seasons

DATASETS_CLUBS = [
  ['eng.1',   %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['eng.2',   %w[2023/24 2022/23 2021/22 2020/21]],
  ['eng.3',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['es.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['es.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['de.1',    %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['de.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['sco.1',  %w[2023/24 2022/23 2021/22 2020/21]], 

  ['it.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['it.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['fr.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['fr.2',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['pt.1',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['nl.1',   %w[2023/24 2022/23 2021/22 2020/21]],
  ['be.1',   %w[2023/24 2022/23 2021/22 2020/21]],

  ['tr.1',  %w[2023/24 2022/23 2021/22 2020/21]],
  ['gr.1',  %w[2023/24 2022/23 2021/22 2020/21]],

  ['ru.1',  %w[2023/24 2022/23 2021/22 2020/21]],
  ['ua.1', %w[2023/24 2022/23 2021/22 2020/21]],
  ['pl.1',  %w[2023/24 2022/23 2021/22 2020/21]],

  ['dk.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['at.1',    %w[2023/24 2022/23 2021/22 2020/21
                 2019/20 2018/19 2017/18 2016/17 2015/16 2014/15]],
  ['ch.1',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['cz.1',    %w[2023/24 2022/23 2021/22 2020/21]],
  ['hr.1',    %w[2023/24 2022/23]],
  ['hu.1',    %w[2023/24 2022/23 2021/22 2020/21]],

  ['no.1',    %w[2024 2023 2022 2021]],
  ['se.1',    %w[2024 2023 2022 2021]],

  ['ie.1',    %w[2024 2023 2022 2021]],

  ## add overseas leagues
#  ['br.1',  %w[2024]],
#  ['ar.1',  %w[2024]], 
]


DATASETS_NATIONAL = [
  ['world',  %w[2022 2018 2014 2010]],
  ['euro',   %w[2024 2020 2016 2012]],
  ## note: starting with euro 2008  has "old" format
  ##           no nat(ionality) and height in 6'02" !!!
  ## note: starting with world 2006 has "old" format
  ##           no nat(inality) and ...

  ## add Copa América  and Africa Cup of Nations 
  ['southamerica', %w[2021 2019 2016]],
  ['africa',  %w[2023 2021 2019]],
]


datasets = DATASETS_CLUBS + DATASETS_NATIONAL 




Webcache.root = '../../../cache'  ### c:\sports\cache
pp Webcache.root



datasets.each_with_index do |(league_key, seasons),i|
 
 
  seasons.each_with_index do |season_key,j|  
    season   =  Season( season_key )
 
    puts "==> [#{i+1}/#{datasets.size}]  #{league_key} #{season_key} [#{j+1}/#{seasons.size}]..."

    add_league( league: league_key, 
                season: season_key )
  end
end


# puts
# puts " players:"
# pp PLAYERS


## check country code
PLAYERS.each do |cc, players|

  country = COUNTRIES.find_by_code( cc )
  if country
     puts "#{cc} => #{country.key} - #{country.name} (#{country.code})   -- #{players.size} player(s)"

     # pp players
     # buf = pp_players( players.values )
     # puts buf
  else
    ## e.g. found  GET is ??
     puts "!! ERROR - no country code found >#{cc}<:"
     pp players
     exit 1
  end
end





OPTS = {
  # push: true
}



repos = ['players']   ## single "mono" repo for now used

## always pull before push!! (use fast_forward)
git_fast_forward_if_clean( repos )  if OPTS[:push]


outdir = if OPTS[:push]
            "/sports/openfootball"
         else
            "./tmp"
         end



CCPATHS = {
  'eng' => 'europe/england',
  'de'  => 'europe/germany',
  'fr'  => 'europe/france',
  'it'  => 'europe/italy',
  'es'  => 'europe/spain',

  'at'  => 'europe/austria',
  'hu'  => 'europe/hungary',
  'ch'  => 'europe/switzerland', 
  'be'  => 'europe/belgium',
  'nl'  => 'europe/netherlands',
  'pt'  => 'europe/portugal',
  'pl'  => 'europe/poland',
  'no'  => 'europe/norway', 

  'ua'  => 'europe/ukraine',
  'ie'  => 'europe/ireland',
  'wal' => 'europe/wales',
  'sco' => 'europe/scotland',
  'nir' => 'europe/northern-ireland',
  
  'ee' => 'europe/estonia',
  'al' => 'europe/albania',
  'ro' => 'europe/romania',
  'dk' =>  'europe/denmark',
  'is' =>  'europe/iceland',
  'se' =>  'europe/sweden',
  'fi' =>  'europe/finland',
  'tr' =>  'europe/turkey', 
  'xk' =>  'europe/kosovo', 
  'mk' =>  'europe/north-macedonia',  ## use macedonia ??
  'rs' =>  'europe/serbia',
  'si' =>  'europe/slovenia',
  'sk' =>  'europe/slovakia',
  'cy' =>  'europe/cyprus',
  'gr' =>  'europe/greece',
  'hr' =>  'europe/croatia',
  'gi' =>  'europe/gibraltar',
  'cz' =>  'europe/czech-republic',
   
   'ba' =>  'europe/bosnia-n-herzegovina',
   'mt' =>  'europe/malta',
   'me' =>  'europe/montenegro',
   'lt' =>  'europe/lithuania',
   'lv' =>  'europe/latvia',

   'am' =>  'europe/armenia',
   'az' =>  'europe/azerbaijan',
   'bg' =>  'europe/bulgaria',
   'ge' =>  'europe/georgia',
   'ru' =>  'europe/russia',
   'lu' =>  'europe/luxembourg',
   
   'ad' =>  'europe/andorra',
   'md' =>  'europe/moldova',
   'li' =>  'europe/liechtenstein',
   'by' =>  'europe/belarus',
    'fo'  =>  'europe/faroe-islands',
    
  

  'mx'  => 'north-america/mexico',
  'us'  => 'north-america/united-states',
  'ca'  => 'north-america/canada',
  'bm'  => 'north-america/bermuda', 


  'cr'   => 'central-america/costa-rica',
  'hn'   => 'central-america/honduras',
  'pa'    => 'central-america/panama',
  'bz'    => 'central-america/belize',
   'ni'  => 'central-america/nicaragua',
   'gt'  => 'central-america/guatemala',
   

  'jm'   =>  'caribbean/jamaica',
  'gd'   =>  'caribbean/grenada',
  'tt'    =>  'caribbean/trinidad-n-tobago',
  'ms'    =>  'caribbean/montserrat',
  'kn'    =>  'caribbean/saint-kitts-n-nevis',
  'cu'    =>  'caribbean/cuba',
  'cw'    =>  'caribbean/curacao',
  'do'    =>  'caribbean/dominican-republic',
  'ag'     =>  'caribbean/antigua-n-barbuda',
  'lc'    =>  'caribbean/saint-lucia',
  'bs'     =>  'caribbean/bahamas',
  'vg'     =>  'caribbean/british-virgin-islands',
  'ht'    =>  'caribbean/haiti',
  'bb'    =>  'caribbean/barbados',
  'pr'    =>  'caribbean/puerto_rico',
   


  'br'  =>  'south-america/brazil',
  'ar'  =>  'south-america/argentina',
  'uy'  =>  'south-america/uruguay',
   'co' =>  'south-america/colombia',
   'py'  =>  'south-america/paraguay',
   'ec'  =>  'south-america/ecuador',
   'cl'  =>  'south-america/chile',
   'pe'  =>  'south-america/peru',
   've' =>   'south-america/venezuela',
   'bo' =>   'south-america/bolivia',
   'gy'  =>  'south-america/guyana',
   'sr' =>   'south-america/suriname',
   

  'gh'   => 'africa/ghana',
  'eg'   => 'africa/egypt',
  'ma'   =>  'africa/morocco',
   'tn'  =>  'africa/tunisia', 
   'cd'  =>  'africa/congo-dr',
   'ng'  =>  'africa/nigeria',
   'cm'  =>  'africa/cameroon',
   'bf'  => 'africa/burkina-faso',
   'ci'  => 'africa/cote-d-ivoire',
   'za'  =>  'africa/south-africa',
   'sn'  => 'africa/senegal',
   'ml'  => 'africa/mali',
   'tg'  => 'africa/togo',
   'zw'  => 'africa/zimbabwe',
   'dz'  => 'africa/algeria',
   'ga'  => 'africa/gabon',
   'zm'  => 'africa/zambia',
   'gn'  => 'africa/guinea',
   'sl'  => 'africa/sierra-leone',
   'ao'  => 'africa/angola',
   'lr'  => 'africa/liberia',
   'tz'  => 'africa/tanzania',
   'mr'  => 'africa/mauritania',
   'gm'  => 'africa/gambia',
   'cf'   => 'africa/central-african-republic',
   'ke'  =>  'africa/kenya',
   'bj'  =>  'africa/benin',
   'gw'  =>  'africa/guinea-bissau',
   'gq'  =>  'africa/equatorial-guinea',
   'cg'  =>  'africa/congo',
    'ne'  =>  'africa/niger',
    'ss'  =>  'africa/south-sudan',
    'ly'  =>  'africa/libya',
    'et'  =>  'africa/ethiopia',
    'mg'  =>  'africa/madagascar',
    'td'  =>  'africa/chad',
    'mu'  =>  'africa/mauritius',
    'rw'   =>  'africa/rwanda',
    'so'   =>  'africa/somalia',
    'er'    =>  'africa/eritrea',
     'st'  =>  'africa/sao-tome-n-principe',
     'cv'  =>  'africa/cabo-verde',
     'ug'   => 'africa/uganda',
     'na'   => 'africa/namibia',
     'km'   => 'africa/comoros',
     'sc'   => 'africa/seychelles',
     'bi'   => 'africa/burundi',
     'mz'    => 'africa/mozambique',
     'sd'    =>  'africa/sudan',
     'mw'    =>  'africa/malawi',     
    'ir'  =>  'middle-east/iran',
   'iq'  =>  'middle-east/iraq',
   'il'  =>  'middle-east/israel',
   'ae'  =>  'middle-east/united-arab-emirates',
   'sa'  =>  'middle-east/saudi-arabia',
   'sy'  =>  'middle-east/syria',
   'qa'  =>  'middle-east/qatar',
   'bh'  =>  'middle-east/bahrain',
    'jo' =>  'middle-east/jordan',
    'ps' =>  'middle-east/palestine',
    'lb' =>  'middle-east/lebanon',
    

   'jp'   => 'asia/japan',
   'kr'   => 'asia/south-korea',
   'cn'   => 'asia/china',
   'sg'   => 'asia/singapore',
   'id'   => 'asia/indonesia',
   'th'   => 'asia/thailand',
   'bn'    => 'asia/brunei',
   'hk'    => 'asia/hong-kong',
   'ph'  => 'asia/philippines',
   'af'  => 'asia/afghanistan',
   'lk'  => 'asia/sri-lanka',
   'vn'  => 'asia/vietnam',
   'my'  => 'asia/malaysia',
   'kz'  => 'asia/kazakhstan',
   'kg'  => 'asia/kyrgyzstan',
   'tj'  => 'asia/tajikistan',
   'kp' => 'asia/north-korea',
   'uz' => 'asia/uzbekistan',
   'mn'  => 'asia/mongolia',
   
   'au'   => 'pacific/australia',
   'nz'   => 'pacific/new-zealand',
   'fj'   => 'pacific/fiji',
}

  
###
#  
#   try to write out some
codes = %w[ENG GER FRA ITA ESP
           AUT BEL NED SUI POR POL
           MEX USA CAN
           BRA ARG URU
          ]

puts
puts "=>  #{codes.size} countries..."
pp codes


codes = PLAYERS.keys   ## use all

codes.each do |cc|
  country = COUNTRIES.find_by_code( cc )
  players = PLAYERS[ cc ].values   ## note: keys are player names only

  puts "#{cc} => #{country.key} - #{country.name} (#{country.code})   -- #{players.size} player(s)"

  buf = String.new
  buf << "=================================\n"
  buf << "=  #{country.name}\n\n"
  buf << pp_players( players )

  ccpath = CCPATHS[ country.key ]
  
  if ccpath
    path = "#{outdir}/players/#{ccpath}/#{country.key}.players.txt"
    write_text( path, buf )
  else
    puts "!! no path configured for country code #{cc} - #{country.name}"
  end
end



## todo/fix: add a getch or something to hit return before commiting pushing - why? why not?
git_push_if_changes( repos )    if OPTS[:push]


=begin
###
#  dump all players with more than one name
PLAYERS.each do |nat, players|
  ## puts "==> #{nat}  -  #{players.size} player(s) ..."
  players.each do |key, rec|
      if rec[:names].size > 1
         puts "!! #{rec[:names].size}"
         puts rec
         pp   rec[:names].sort { |l,r| r.bytesize <=> l.bytesize }
      end
  end
end
=end

puts "bye"

