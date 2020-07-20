require_relative '../boot'


########
# helpers
#   normalize team names
def normalize( matches, league: )
    matches = matches.sort do |l,r|
      ## first by date (older first)
      ## next by matchday (lower first)
      res =   l.date <=> r.date
      res =   l.round <=> r.round   if res == 0
      res
    end


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


def write_worker( league, season, source:,
                                  extra: nil,
                                  split: false,
                                  normalize: true )
  season = SportDb::Import::Season.new( season )  ## normalize season

  league_info = LEAGUES[ league ]

  source_info = SOURCES[ source ]
  source_path = source_info[:path]

  in_path = "#{source_path}/#{season.path}/#{league}.csv"   # e.g. ../stage/one/2020/br.1.csv

  matches = SportDb::CsvMatchParser.read( in_path )

  pp matches[0]
  puts "#{matches.size} matches"


  matches = normalize( matches, league: league )   if normalize

  league_name  = league_info[ :name ]      # e.g. Brasileiro Série A
  basename     = league_info[ :basename]   #.e.g  1-seriea

  league_name =  league_name.call( season )   if league_name.is_a?( Proc )  ## is proc/func - name depends on season
  basename    =  basename.call( season )      if basename.is_a?( Proc )  ## is proc/func - name depends on season

  repo_path    = league_info[ :path ]      # e.g. brazil or world/europe/portugal etc.

  season_path = String.new('')    ## note: allow extra path for output!!!! e.g. archive/2000s etc.
  season_path << "#{extra}/"   if extra
  season_path << season.path


  lang_info = LANGS[ league_info[ :lang ] ]

  if split
    matches_i, matches_ii = split_matches( matches, season: season )

    out_path = "./o/#{repo_path}/#{season_path}/#{basename}-i.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_i,
                                   name: "#{league_name} #{season.key}",
                                   round: lang_info[ :round ],
                                   lang:  lang_info[ :lang] )

    out_path = "./o/#{repo_path}/#{season_path}/#{basename}-ii.txt"

    SportDb::TxtMatchWriter.write( out_path, matches_ii,
                                   name: "#{league_name} #{season.key}",
                                   round: lang_info[ :round ],
                                   lang:  lang_info[ :lang] )
  else
    out_path = "../../../openfootball/#{repo_path}/#{season_path}/#{basename}.txt"
    # out_path = "./o/#{repo_path}/#{season_path}/#{basename}.txt"

    SportDb::TxtMatchWriter.write( out_path, matches,
                                   name: "#{league_name} #{season.key}",
                                   round: lang_info[ :round ],
                                   lang:  lang_info[ :lang] )
  end
end


def write_br( season, source: 'one' )   write_worker( 'br.1', season, source: source ); end

def write_nl( season, source: 'one' )   write_worker( 'nl.1', season, source: source ); end

def write_pt( season, source: 'one' )   write_worker( 'pt.1', season, source: source ); end

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

def write_eng(  season, source: 'one', extra: nil )  write_worker( 'eng.1', season, source: source, extra: extra ); end
def write_eng2( season, source: 'one', extra: nil )  write_worker( 'eng.2', season, source: source, extra: extra ); end
def write_eng3( season, source: 'two', extra: nil )  write_worker( 'eng.3', season, source: source, extra: extra ); end
def write_eng4( season, source: 'two', extra: nil )  write_worker( 'eng.4', season, source: source, extra: extra ); end

def write_de(   season, source: 'leagues', extra: nil, split: false, normalize: true )  write_worker( 'de.1', season, source: source, extra: extra, split: split, normalize: normalize ); end
def write_de2(  season, source: 'leagues', extra: nil, split: false, normalize: true )  write_worker( 'de.2', season, source: source, extra: extra, split: split, normalize: normalize ); end
def write_de3(  season, source: 'leagues', extra: nil, split: false, normalize: true )  write_worker( 'de.3', season, source: source, extra: extra, split: split, normalize: normalize ); end
def write_de_cup(  season, source: 'two', split: false, normalize: true )  write_worker( 'de.cup', season, source: source, split: split, normalize: normalize ); end

def write_at(  season, source: 'two', split: false, normalize: true )  write_worker( 'at.1', season, source: source, split: split, normalize: normalize ); end
def write_at2( season, source: 'two', split: false, normalize: true )  write_worker( 'at.2', season, source: source, split: split, normalize: normalize ); end
def write_at_cup( season, source: 'two', split: false, normalize: true )  write_worker( 'at.cup', season, source: source, split: split, normalize: normalize ); end


SOURCES = {
  'one'     =>  { path: '../../stage/one' },
  'tmp/one'     =>  { path: '../apis/o' },  ## "tmp" debug version

  'two'     =>  { path: '../../stage/two' },
  'tmp/two'   =>  { path: '../more/o' },    ## "tmp" debug version

  'leagues'   =>  { path: '../../../footballcsv/cache.leagues' },
  'tmp/leagues' =>  { path: '../cache.leagues/o' },    ## "tmp"  debug version
}


LEAGUES =
{
  'br.1' => { name:     'Brasileiro Série A',  ## league name
              basename: '1-seriea',
              path:     'brazil',              ## repo path
              lang:     'pt_BR',
            },
  'ru.1' => { name:     'Russian Premier League',
              basename: '1-premierliga',
              path:     'russia',
              lang:     'en',   ## note: use english for now
            },
  'ru.2' => { name:     'Russian 1. Division',
              basename: '2-division1',
              path:     'russia',
              lang:     'en',
            },
  'nl.1' => { name:     'Dutch Eredivisie',
              basename: '1-eredivisie',
              path:     'world/europe/netherlands',
              lang:     'en',   ## note: use english for now
            },
  'pt.1' => { name:     'Portuguese Primeira Liga',
              basename: '1-primeiraliga',
              path:     'world/europe/portugal',
              lang:     'pt_PT',
            },
  'ch.1' => { name:     'Swiss Super League',
              basename: '1-superleague',
              path:     'world/europe/switzerland',
              lang:     'de_CH',
            },
  'ch.2' => { name:     'Swiss Challenge League',
              basename: '2-challengeleague',
              path:     'world/europe/switzerland',
              lang:     'de_CH',
            },
  'tr.1' => { name:     'Turkish Süper Lig',
              basename: '1-superlig',
              path:     'world/europe/turkey',
              lang:     'en',   ## note: use english for now
            },
  'tr.2' => { name:     'Turkish 1. Lig',
              basename: '2-lig1',
              path:     'world/europe/turkey',
              lang:     'en',   ## note: use english for now
            },
  'it.1' => { name:     'Italian Serie A',
              basename: '1-seriea',
              path:     'italy',
              lang:     'it',
            },
  'it.2' => { name:     'Italian Serie B',
              basename: '2-serieb',
              path:     'italy',
              lang:     'it',
            },
  'fr.1' => { name:     'French Ligue 1',
              basename: '1-ligue1',
              path:     'france',
              lang:     'fr',
          },
  'fr.2' => { name:     'French Ligue 2',
              basename: '2-ligue2',
              path:     'france',
              lang:     'fr',
            },
  'es.1' => { name:     'Primera División de España',
              basename: '1-liga',
              path:     'espana',
              lang:     'es',
            },
  'es.2' => { name:     'Segunda División de España',
              basename: '2-liga2',
              path:     'espana',
              lang:     'es',
            },
  'eng.1' => { name:     'English Premier League',
               basename: '1-premierleague',
               path:     'england',
               lang:     'en',
             },
  'eng.2' => { name:     'English Championship',
               basename: '2-championship',
               path:     'england',
               lang:     'en',
             },
  'eng.3' => { name:     'English League One',
               basename: '3-league1',
               path:     'england',
               lang:     'en',
             },
  'eng.4' => { name:     'English League Two',
               basename: '4-league2',
               path:     'england',
               lang:     'en',
             },
  'de.1' => { name:     'Deutsche Bundesliga',
              basename: '1-bundesliga',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.2' => { name:     'Deutsche 2. Bundesliga',
              basename: '2-bundesliga2',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.3' => { name:     'Deutsche 3. Liga',
              basename: '3-liga3',
              path:     'deutschland',
              lang:     'de_DE',
            },
  'de.cup' => { name:     'DFB Pokal',
                basename: 'cup',
                path:     'deutschland',
                lang:     'de_DE',
              },
  'at.1' => { name:     'Österr. Bundesliga',
              basename: '1-bundesliga',
              path:     'austria',
              lang:     'de_AT',
            },
  'at.2' => { name:     ->(season) { season.start_year >= 2018 ? 'Österr. 2. Liga' : 'Österr. Erste Liga' },
              basename: ->(season) { season.start_year >= 2018 ? '2-liga2' : '2-liga1' },
              path:     'austria',
              lang:     'de_AT',
            },
  'at.cup' => { name:     'ÖFB Cup',
                basename: 'cup',
                path:     'austria',
                lang:     'de_AT',
              },
}


LANGS =
{
  'en'    => { round: 'Matchday', lang: 'en' },
  'pt_BR' => { round: 'Rodada',   lang: 'pt' },
  'pt_PT' => { round: 'Jornada',  lang: 'pt' },
  'de_DE' => { round: 'Spieltag', lang: 'de' },
  'de_CH' => { round: 'Spieltag', lang: 'de' },  # note: for now 1:1 like de_DE
  'de_AT' => { round: ->(round) { "%s. Runde" % round },
               lang: 'de'
             },
  'it'    => { round: ->(round) { "%s^ Giornata" % round },
               lang: 'it'
             },
  'fr'    => { round: 'Journée',  lang:  'fr' },
  'es'    => { round: 'Jornada',  lang:  'es' },
}



# write_at_cup( '2018/19', source: 'tmp/two' )
# write_at_cup( '2019/20', source: 'tmp/two' )

write_at_cup( '2011/12', source: 'tmp/two' )
write_at_cup( '2012/13', source: 'tmp/two' )
write_at_cup( '2013/14', source: 'tmp/two' )
write_at_cup( '2014/15', source: 'tmp/two' )
write_at_cup( '2015/16', source: 'tmp/two' )



# write_at( '2010-11', split: true, normalize: false )
# write_at2( '2010-11', split: true, normalize: false )

# write_at( '2011-12', split: true, normalize: false )
# write_at2( '2011-12', split: true, normalize: false )

# write_at( '2012-13', split: true, normalize: false )

# write_at( '2013-14', split: true, normalize: false )

# write_at( '2014-15', split: true, normalize: false )

# write_at( '2015-16', split: true, normalize: false )
# write_at( '2016-17', split: true, normalize: false )
# write_at( '2017-18', split: true, normalize: false )

# write_at2( '2018-19', normalize: false )
# write_at2( '2019-20', normalize: false )


# write_de_cup( '2018/19', source: 'tmp/two' )
# write_de_cup( '2019/20', source: 'tmp/two' )

# write_de( '2010-11' )
# write_de( '2011-12' )
# write_de( '2012-13', split: true )

# write_de( '2013-14', split: true )
# write_de2( '2013-14', source: 'two', split: true )

# write_de( '2014-15', split: true )
# write_de2( '2014-15', split: true )
# write_de3( '2014-15', split: true )

# write_de( '2015-16', split: true )
# write_de2( '2015-16', split: true )
# write_de3( '2015-16', split: true )

# write_de( '2016-17', split: true )
# write_de2( '2016-17', split: true )
# write_de3( '2016-17', split: true )

# write_de( '2017-18', split: true )
# write_de2( '2017-18', split: true )
# write_de3( '2017-18', split: true )

# write_de2( '2019/20' )
# write_de3( '2019/20' )

# write_de2( '2018/19' )
# write_de3( '2018/19' )


# write_eng( '1992/93', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1993/94', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1994/95', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1995/96', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1996/97', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '1997/98', source: 'leagues', extra: 'archive/1990s' )
# write_eng( '2000/01', source: 'leagues', extra: 'archive/2000s')

# write_eng( '2001/02', source: 'leagues', extra: 'archive/2000s')
# write_eng( '2002/03', source: 'leagues', extra: 'archive/2000s')
# write_eng( '2003/04', source: 'leagues', extra: 'archive/2000s')


# write_eng( '2010/11', source: 'leagues' )
# write_eng( '2011/12', source: 'leagues' )
# write_eng( '2012/13', source: 'leagues' )
# write_eng( '2013/14', source: 'leagues' )
# write_eng( '2014/15', source: 'leagues' )
# write_eng( '2015/16', source: 'leagues' )
# write_eng( '2016/17', source: 'leagues' )
# write_eng( '2017/18', source: 'leagues' )

# write_eng( '2018/19' )


# write_eng2( '2018/19' )

# write_eng( '2019/20' )
# write_eng2( '2019/20' )

# write_eng3( '2019/20' )
# write_eng4( '2019/20' )

# write_eng3( '2018/19' )
# write_eng4( '2018/19' )


# write_es( '2012/13', source: 'leagues' )
# write_es( '2013/14', source: 'leagues' )
# write_es( '2014/15', source: 'leagues' )
# write_es( '2015/16', source: 'leagues' )
# write_es( '2016/17', source: 'leagues' )
# write_es( '2017/18', source: 'leagues' )
# write_es( '2018/19', source: 'leagues' )
# write_es( '2019/20' )

# write_es2( '2012/13' )
# write_es2( '2013/14' )
# write_es2( '2014/15' )
# write_es2( '2015/16' )
# write_es2( '2016/17' )
# write_es2( '2017/18' )
# write_es2( '2018/19' )
# write_es2( '2019/20' )

# write_fr( '2014/15' )
# write_fr2( '2014/15' )
# write_fr( '2015/16' )
# write_fr( '2016/17' )
# write_fr( '2017/18' )
# write_fr( '2018/19' )
# write_fr( '2019/20', source: 'one' )

# write_fr2( '2015/16' )
# write_fr2( '2016/17' )
# write_fr2( '2017/18' )
# write_fr2( '2018/19' )
# write_fr2( '2019/20' )


# write_it( '2019/20' )

# write_it( '2013/14', source: 'leagues' )
# write_it( '2014/15', source: 'leagues' )
# write_it( '2015/16', source: 'leagues' )
# write_it( '2016/17', source: 'leagues' )
# write_it( '2017/18', source: 'leagues' )
# write_it( '2018/19', source: 'leagues' )

# write_it2( '2013/14' )
# write_it2( '2014/15' )
# write_it2( '2015/16' )
# write_it2( '2016/17' )
# write_it2( '2017/18' )
# write_it2( '2018/19' )

# write_it2( '2019/20' )


# write_ch( '2019/20' )
# write_ch2( '2019/20' )

# write_tr( '2019/20' )
# write_tr2( '2019/20' )

# write_nl( '2018/19' )
# write_nl( '2019/20' )

# write_pt( '2018/19' )
# write_pt( '2019/20' )

# write_ru( '2019/20' )
# write_ru2( '2019/20' )

# write_br( '2018' )
# write_br( '2019' )
# write_br( '2020' )

puts "bye"