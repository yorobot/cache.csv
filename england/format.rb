###
#  (re)format datafile

require '../boot'


OUT_DIR='../../../openfootball/england'
# OUT_DIR='./o'



def read_matches( path )
  secs = SportDb::LeagueOutlineReader.read( path )

  if secs.size != 1
    puts "!! ERROR: got #{secs.size} sections(s); expected 1:"
    pp secs
    exit 1
  end

  sec = secs[0]
  ## pp sec

  season = sec[:season]
  league = sec[:league]
  stage  = sec[:stage]
  lines  = sec[:lines]

  start = if season.year?
            Date.new( season.start_year, 1, 1 )
          else
            Date.new( season.start_year, 7, 1 )
          end

  auto_conf_teams, _ = SportDb::AutoConfParser.parse( lines,
                                                    start: start )
  pp auto_conf_teams


  matches, _ = SportDb::MatchParser.parse( lines,
                                            auto_conf_teams.keys,
                                            start: start )   ## note: keep season start_at date for now (no need for more specific stage date need for now)


  puts "#{matches.size} matches:"


  ## convert rounds / matchday to integer from string
  ##   e.g. "Matchday 1"  => 1
  matches = matches.map do |match|
    if match.round =~ /\b(?:Matchday|Round) (\d+)\b/
      match.update( round: $1.to_i )
    else
      puts "!! ERROR - expected matchday in match.round:"
      pp match
      exit 1
    end
    match
  end

  ## (re)sort by 1) date and 2) matchday
  matches = matches.sort do |l,r|
    res =  l.date  <=> r.date    ## oldest first
    res =  l.round <=> r.round   if res == 0
    res
  end

  # pp matches

  puts "#{matches.size} matches"
  matches
end



def write_eng( season,   basename:,
                         name:,
                         extra: nil )
    season_path = String.new('')
    season_path << "#{extra}/"   if extra   ## extra path e.g. archive/1990s or such
    season_path << season.path

    in_path = "../../../openfootball/england/#{season_path}/#{basename}.txt"
    puts "basename: >#{basename}<, in_path: >#{in_path}<"

    matches = read_matches( in_path )

   out_path = "#{OUT_DIR}/#{season_path}/#{basename}.txt"
   SportDb::TxtMatchWriter.write( out_path, matches,
                             title: "#{name} #{season.key}",
                             round: 'Matchday',
                             lang:  'en')
end


def write_eng1( season_q, extra: nil )
  season = SportDb::Import::Season.new( season_q )

  basename = 'premierleague'
  name     = 'English Premier League'

  write_eng( season,   basename: "1-#{basename}",
                       name:     name,
                       extra:    extra )
end

def write_eng2( season_q, extra: nil )
  season = SportDb::Import::Season.new( season_q )

  basename, name = if season.start_year >= 2004
                     ['championship', 'English Championship' ]
                   else
                     ['division1', 'English Division One' ]
                   end

  write_eng( season,   basename: "2-#{basename}",
                       name:     name,
                       extra:    extra )
end

def write_eng3( season_q, extra: nil )
  season = SportDb::Import::Season.new( season_q )

  basename, name = if season.start_year >= 2004
                     ['league1', 'English League One' ]
                   else
                     ['division2', 'English Division Two' ]
                   end

  write_eng( season,   basename: "3-#{basename}",
                       name:     name,
                       extra:    extra )
end

def write_eng4( season_q, extra: nil )
  season = SportDb::Import::Season.new( season_q )

  basename, name = if season.start_year >= 2004
                     ['league2', 'English League Two' ]
                   else
                     ['division3', 'English Division Three' ]
                   end

  write_eng( season,   basename: "4-#{basename}",
                       name:     name,
                       extra:    extra )
end


# write_eng1( '1998/99', extra: 'archive/1990s' )
# write_eng2( '1998/99', extra: 'archive/1990s' )
# write_eng3( '1998/99', extra: 'archive/1990s' )
# write_eng4( '1998/99', extra: 'archive/1990s' )

# write_eng1( '1999/00', extra: 'archive/1990s' )
# write_eng2( '1999/00', extra: 'archive/1990s' )
# write_eng3( '1999/00', extra: 'archive/1990s' )
# write_eng4( '1999/00', extra: 'archive/1990s' )

# write_eng1( '2000/01', extra: 'archive/2000s' )
# write_eng1( '2001/02', extra: 'archive/2000s' )
# write_eng1( '2002/03', extra: 'archive/2000s' )
# write_eng1( '2003/04', extra: 'archive/2000s' )
# write_eng1( '2004/05', extra: 'archive/2000s' )
# write_eng1( '2005/06', extra: 'archive/2000s' )
# write_eng1( '2006/07', extra: 'archive/2000s' )
# write_eng1( '2007/08', extra: 'archive/2000s' )
# write_eng1( '2008/09', extra: 'archive/2000s' )
# write_eng1( '2009/10', extra: 'archive/2000s' )


# write_eng2( '2000/01', extra: 'archive/2000s' )
# write_eng3( '2000/01', extra: 'archive/2000s' )
# write_eng4( '2000/01', extra: 'archive/2000s' )

# write_eng2( '2001/02', extra: 'archive/2000s' )
# write_eng3( '2001/02', extra: 'archive/2000s' )
# write_eng4( '2001/02', extra: 'archive/2000s' )

# write_eng2( '2002/03', extra: 'archive/2000s' )
# write_eng3( '2002/03', extra: 'archive/2000s' )
# write_eng4( '2002/03', extra: 'archive/2000s' )

# write_eng2( '2003/04', extra: 'archive/2000s' )
# write_eng3( '2003/04', extra: 'archive/2000s' )
# write_eng4( '2003/04', extra: 'archive/2000s' )



write_eng2( '2004/05', extra: 'archive/2000s' )
write_eng3( '2004/05', extra: 'archive/2000s' )
write_eng4( '2004/05', extra: 'archive/2000s' )

write_eng2( '2005/06', extra: 'archive/2000s' )
write_eng3( '2005/06', extra: 'archive/2000s' )
write_eng4( '2005/06', extra: 'archive/2000s' )

write_eng2( '2006/07', extra: 'archive/2000s' )
write_eng3( '2006/07', extra: 'archive/2000s' )
write_eng4( '2006/07', extra: 'archive/2000s' )

write_eng2( '2007/08', extra: 'archive/2000s' )
write_eng3( '2007/08', extra: 'archive/2000s' )
write_eng4( '2007/08', extra: 'archive/2000s' )

write_eng2( '2008/09', extra: 'archive/2000s' )
write_eng3( '2008/09', extra: 'archive/2000s' )
write_eng4( '2008/09', extra: 'archive/2000s' )

write_eng2( '2009/10', extra: 'archive/2000s' )
write_eng3( '2009/10', extra: 'archive/2000s' )
write_eng4( '2009/10', extra: 'archive/2000s' )


# write_eng1( '2010/11' )
# write_eng1( '2011/12' )

# write_eng2( '2010/11' )
# write_eng2( '2011/12' )
# write_eng2( '2012/13' )
# write_eng2( '2013/14' )
# write_eng2( '2014/15' )
# write_eng2( '2015/16' )

# write_eng3( '2010/11' )
# write_eng3( '2011/12' )
# write_eng3( '2012/13' )
# write_eng3( '2013/14' )
# write_eng3( '2014/15' )
# write_eng3( '2015/16' )

# write_eng4( '2010/11' )
# write_eng4( '2011/12' )
# write_eng4( '2012/13' )
# write_eng4( '2013/14' )
# write_eng4( '2014/15' )
# write_eng4( '2015/16' )

