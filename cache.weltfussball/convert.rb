require 'pp'
require 'nokogiri'

$LOAD_PATH.unshift( File.expand_path( '../../../sportdb/sport.db/sportdb-formats/lib') )
require 'sportdb/formats'   ## for Season -- move to test_schedule /fetch!!!!

require_relative '../csv'


require_relative './parse'
require_relative './build'


# OUT_DIR='./o'
# OUT_DIR='./o/fr'
# OUT_DIR='./o/at'
# OUT_DIR='./o/de'
# OUT_DIR='./o/eng'
# OUT_DIR='../../stage/two'

OUT_DIR='./o/aug7'
# OUT_DIR='./tmp'



def convert( season:, league: )
  season = Season.new( season )  if season.is_a?( String )

   # season   = '2019/20'
   # basename = 'at.2'
  basename =   league
  season_path = season.to_path( :long )  # e.g. 2010-2011  etc.

  path = "./dl/weltfussball-#{basename}-#{season_path}.html"

   html =  File.open( path, 'r:utf-8' ) { |f| f.read }

   rows = parse( html )
   recs = build( rows, season: season, league: league )

   pp recs[0]   ## check first record

##   note:  sort matches by date before saving/writing!!!!
##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
## note: assume date is third column!!! (stage/round/date/...)
recs = recs.sort { |l,r| l[2] <=> r[2] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each { |rec| rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

   ## remove unused columns (e.g. stage, et, p, etc.)
   recs, headers = vacuum( recs )

   puts headers
   pp recs[0]   ## check first record

   out_path = "#{OUT_DIR}/#{season.path}/#{basename}.csv"

   puts "write #{out_path}..."
   Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end



def convert_with_stages( season:, league:, stages:, offset: nil )  ## check: rename (optional) offset to time_offset or such?
  season = Season.new( season )  if season.is_a?( String )

   # season   = '2019/20'
   # basename = 'at.2'
  basename =   league
  season_path = season.to_path( :long )  # e.g. 2010-2011  etc.

  recs = []
  stages.each do |stage_key, stage_name|
    path = "./dl/weltfussball-#{basename}-#{season_path}-#{stage_key}.html"

    unless File.exist?( path )
      puts "!! WARN - missing stage >#{stage_name}< source - >#{path}<"
      next
    end

    html =  File.open( path, 'r:utf-8' ) { |f| f.read }

    rows = parse( html )
    stage_recs = build( rows, season: season, league: league, stage: stage_name )

    pp stage_recs[0]   ## check first record
    recs += stage_recs
  end

  ##   note:  sort matches by date before saving/writing!!!!
  ##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
  ## note: assume date is third column!!! (stage/round/date/...)


  recs = recs.map { |rec| fix_date( rec, offset ) }    if offset


  recs = recs.sort { |l,r| l[2] <=> r[2] }
  ## reformat date / beautify e.g. Sat Aug 7 1993
  recs.each { |rec| rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

   ## remove unused columns (e.g. stage, et, p, etc.)
   recs, headers = vacuum( recs )

   puts headers
   pp recs[0]   ## check first record

   out_path = "#{OUT_DIR}/#{season.path}/#{basename}.csv"

   puts "write #{out_path}..."
   Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end


## helper to fix dates to use local timezone (and not utc/london time)
def fix_date( row, offset )
  return row    if row[3].nil? || row[3].empty?   ## note: time (column) required for fix

  col = row[2]
  if col =~ /^\d{4}-\d{2}-\d{2}$/
    date_fmt = '%Y-%m-%d'   # e.g. 2002-08-17
  else
    puts "!!! ERROR - wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
    ## todo/fix: add to errors/warns list - why? why not?
    exit 1
  end

  date = DateTime.strptime( "#{row[2]} #{row[3]}", "#{date_fmt} %H:%M" )
  ## NOTE - MUST be -7/24.0!!!! or such to work
  date = date + (offset/24.0)

  row[2] = date.strftime( date_fmt )  ## overwrite "old"
  row[3] = date.strftime( '%H:%M' )
  row   ## return row for possible pipelining - why? why not?
end


=begin
DATAFILES = [['at.1',  %w[2010/11 2011/12 2012/13 2013/14 2014/15
                          2015/16 2016/17 2017/18]],
             ['at.2',  %w[2010/11 2011/12
                          2018/19 2019/20]],
             ['de.2',  %w[2013/14]],
             ['eng.3', %w[2018/19 2019/20]],
             ['eng.4', %w[2017/18 2018/19 2019/20]],

             ['ch.1', %w[2019/20]],
             ['ch.2', %w[2019/20]],

             ['fr.2', %w[2019/20]],

             ['it.2', %w[2019/20]],

             ['ru.1', %w[2019/20]],
             ['ru.2', %w[2019/20]],

             ['tr.1', %w[2019/20]],
             ['tr.2', %w[2019/20]],
            ]
=end

=begin
DATAFILES = [
  ['it.2', %w[2013/14 2014/15 2015/16 2016/17 2017/18 2018/19]],
  ['fr.2', %w[2015/16 2016/17 2017/18 2018/19]],
  ['es.2', %w[2012/13 2013/14 2014/15 2015/16 2016/17 2017/18 2018/19 2019/20]],
]

pp DATAFILES

DATAFILES.each do |datafile|
  basename = datafile[0]
  datafile[1].each do |season|
    convert( league: basename, season: season )
  end
end
=end


# convert( league: 'at.cup', season: '2019/20' )
# convert( league: 'at.cup', season: '2018/19' )

# convert( league: 'at.cup', season: '2011/12' )
# convert( league: 'at.cup', season: '2012/13' )
# convert( league: 'at.cup', season: '2013/14' )
# convert( league: 'at.cup', season: '2014/15' )
# convert( league: 'at.cup', season: '2015/16' )
# convert( league: 'at.cup', season: '2016/17' )
# convert( league: 'at.cup', season: '2017/18' )

# convert( league: 'at.2', season: '2014/15' )
# convert( league: 'at.2', season: '2015/16' )
# convert( league: 'at.2', season: '2016/17' )
# convert( league: 'at.2', season: '2017/18' )


# convert( league: 'de.cup', season: '2019/20' )
# convert( league: 'de.cup', season: '2018/19' )

# convert( league: 'de.cup', season: '2012/13' )
# convert( league: 'de.cup', season: '2013/14' )
# convert( league: 'de.cup', season: '2014/15' )
# convert( league: 'de.cup', season: '2015/16' )
# convert( league: 'de.cup', season: '2016/17' )
# convert( league: 'de.cup', season: '2017/18' )

# convert( league: 'eng.5', season: '2018/19' )
# convert( league: 'eng.5', season: '2019/20' )

# convert( league: 'eng.cup', season: '2018/19' )
# convert( league: 'eng.cup', season: '2019/20' )

# convert( league: 'eng.cup.l', season: '2019/20' )


# convert( league: 'eng.4', season: '2019/20' )
# convert( league: 'eng.4', season: '2018/19' )
# convert( league: 'eng.4', season: '2017/18' )


# convert( league: 'fr.1', season: '2020/21' )
# convert( league: 'fr.2', season: '2020/21' )


# convert( league: 'se.1', season: '2020' )
# convert( league: 'se.1', season: '2019' )

# convert( league: 'se.2', season: '2020' )
# convert( league: 'se.2', season: '2019' )

convert( league: 'no.1', season: '2020' )
convert( league: 'no.1', season: '2019' )



=begin
stages = { regular:      'Regular Season',
           championship: 'Playoffs - Championship',
           relegation:   'Playoffs - Relegation' }

convert_with_stages( league: 'sco.1', season: '2020/21', stages: stages )
convert_with_stages( league: 'sco.1', season: '2019/20', stages: stages )
convert_with_stages( league: 'sco.1', season: '2018/19', stages: stages )


stages = { regular:       'Regular Season',
           championship:  'Playoffs - Championship',
           europa:        'Playoffs - Europa League',
           europa_finals: 'Playoffs - Europa League - Finals' }

convert_with_stages( league: 'be.1', season: '2020/21', stages: stages )
convert_with_stages( league: 'be.1', season: '2019/20', stages: stages )
convert_with_stages( league: 'be.1', season: '2018/19', stages: stages )
=end

# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019/
# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019-meisterschaft/
# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019-abstieg/
# https://www.weltfussball.de/alle_spiele/fin-veikkausliiga-2019-playoff-el/


=begin
stages = { regular:       'Regular Season',
           championship:  'Playoffs - Championship',
           challenger:    'Playoffs - Challenger',
           europa_finals: 'Europa League Finals' }

convert_with_stages( league: 'fi.1', season: '2020', stages: stages )
convert_with_stages( league: 'fi.1', season: '2019', stages: stages )
=end

=begin
stages = { apertura:        'Apertura',
           apertura_finals: 'Apertura - Liguilla',
           clausura:        'Clausura',
           clausura_finals: 'Clausura - Liguilla' }


## note: adjust date/time by -7 offset
convert_with_stages( league: 'mx.1', season: '2020/21', stages: stages, offset: -7 )
convert_with_stages( league: 'mx.1', season: '2019/20', stages: stages, offset: -7 )
convert_with_stages( league: 'mx.1', season: '2018/19', stages: stages, offset: -7 )
=end
