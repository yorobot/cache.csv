require_relative '../boot'



class EventInfo
  ##  "high level" info (summary) about event  (like a "wikipedia infobox")
  ##    use for checking dataset imports; lets you check e.g.
  ##    - dates within range
  ##    - number of teams e.g. 20
  ##    - matches played e.g. 380
  ##    - goals scored e.g. 937
  ##    etc.

  attr_reader :league,
              :season,
              :teams,
              :matches,
              :goals,
              :start_date,
              :end_date

  def initialize( league:, season:,
                  start_date: nil, end_date: nil,
                  teams:   nil,
                  matches: nil,
                  goals:   nil )

    @league      = league
    @season      = season

    @start_date  = start_date
    @end_date    = end_date

    @teams       = teams    ## todo/check: rename/use teams_count ??
    @matches     = matches  ## todo/check: rename/use match_count ??
    @goals       = goals
  end

  def include?( date )
     ## todo/fix: add options e.g.
     ##  - add delta/off_by_one or such?
     ##  - add strict (for) only return true if date range (really) defined (no generic auto-rules)

    ### note: for now allow off by one error (via timezone/local time errors)
    ##    todo/fix: issue warning if off by one!!!!
    if @start_date && @end_date
      date >= (@start_date-1) &&
      date <= (@end_date+1)
    else
      if @season.year?
         # assume generic rule
         ## same year e.g. Jan 1 - Dec 31; always true for now
         date.year == @season.start_year
      else
         # assume generic rule
         ##  July 1 - June 30 (Y+1)
         ##  - todo/check -start for some countries/leagues in June 1 or August 1 ????
         date >= Date.new( @season.start_year, 7, 1 ) &&
         date <= Date.new( @season.end_year, 6, 30 )
      end
    end
  end  # method include?
  alias_method :between?, :include?

end # class EventInfo


class EventInfoReader
  def self.read( path )
    txt = File.open( path, 'r:utf-8') {|f| f.read }
    new( txt ).parse
  end

  def self.parse( txt )
    new( txt ).parse
  end

  def initialize( txt )
    @txt = txt
  end

  def parse
    recs = []

    CsvHash.parse( @txt, :header_converters => :symbol  ) do |row|
      league_col = row[:league]
      season_col = row[:season]
      dates_col  = row[:dates]

      season = SportDb::Import::Season.new( season_col )
      league = SportDb::Import.catalog.leagues.find!( league_col )


      dates = []
      if dates_col.nil? || dates_col.empty?
         ## do nothing; no dates - keep dates array empty
      else
        ## squish spaces
        dates_col = dates_col.gsub( /[ ]{2,}/, ' ' )  ## squish/fold spaces

        puts "#{league.name} (#{league.key}) | #{season.key} | #{dates_col}"

        parts = dates_col.split( /[ ]*[–-][ ]*/ )
        if parts.size != 2
          puts "!! ERRROR - expected data range / period - two dates; got #{parts.size}:"
          pp dates_col
          pp parts
          exit 1
        else
          pp parts
          dates << DateFormats.parse( parts[0], start: Date.new( season.start_year, 1, 1 ), lang: 'en' )
          dates << DateFormats.parse( parts[1], start: Date.new( season.end_year ? season.end_year : season.start_year, 1, 1 ), lang: 'en' )
          pp dates

          ## assert/check if period is less than 365 days for now
          diff = dates[1].to_date.jd - dates[0].to_date.jd
          puts "#{diff}d"
          if diff > 365
            puts "!! ERROR - date range / period assertion failed; expected diff < 365 days"
            exit 1
          end
        end
      end


      teams_col    = row[:clubs] || row[:teams]
      matches_col  = row[:matches]
      goals_col    = row[:goals]

      ## note: remove (and allow) all non-digits e.g. 370 goals, 20 clubs, etc.
      teams_col    = teams_col.gsub( /[^0-9]/, '' )    if teams_col
      matches_col  = matches_col.gsub( /[^0-9]/, '' )  if matches_col
      goals_col    = goals_col.gsub( /[^0-9]/, '' )    if goals_col


      rec = EventInfo.new( league:     league,
                           season:     season,
                           start_date: dates[0],
                           end_date:   dates[1],
                           teams:      (teams_col.nil?   || teams_col.empty?)   ? nil : teams_col.to_i,
                           matches:    (matches_col.nil? || matches_col.empty?) ? nil : matches_col.to_i,
                           goals:      (goals_col.nil?   || goals_col.empty?)   ? nil : goals_col.to_i
                         )
      recs << rec
    end  # each row
    recs
  end  # method parse
end  # class EventInfoReader



class EventIndex

  def self.build( path )
    datafiles = SportDb::Package.find_seasons( path )

    puts
    puts "#{datafiles.size} seasons datafile(s):"
    pp datafiles

    index = new
    datafiles.each do |datafile|
      recs = EventInfoReader.read( datafile )
      # pp recs

      index.add( recs )
    end

    index
  end


  attr_reader :events
  def initialize
    @events  = []
    @leagues = {}
  end

  def add( recs )
    @events += recs  ## add to "linear" records

    recs.each do |rec|
      league = rec.league
      season = rec.season

      seasons = @leagues[ league.key ] ||= {}
      seasons[season.key] = rec
    end
    ## build search index by leagues (and season)
  end

  def find_by( league:, season: )
    league_key = league.is_a?( String ) ? league : league.key
    season_key = season.is_a?( String ) ? season : season.key

    seasons = @leagues[ league_key ]
    if seasons
      seasons[ season_key ]
    else
      nil
    end
  end # method find_by
end  ## class EventIndex



class SeasonIndex
     def initialize( *args )
        @leagues = {}   ## use a league hash by years for now; change later

        if args.size == 1 && args[0].is_a?( EventIndex )
          ## convenience setup/hookup
          ##  (auto-)add all events from event index
          add( args[0].events )
        else
          pp args
          raise ArgumentError.new( "unsupported arguments" )
        end
     end

     def add( recs )
       ## use a lookup index by year for now
       ##  todo - find something better/more generic for searching/matching date periods!!!
       recs.each do |rec|
         league = rec.league
         season = rec.season

         years = @leagues[ league.key ] ||= {}
         if season.year?
           years[season.start_year] ||= []
           years[season.start_year] << rec
         else
           years[season.start_year] ||= []
           years[season.end_year]   ||= []
           years[season.start_year] << rec
           years[season.end_year]   << rec
         end
       end
     end # method add

     def find_by( date:, league: )
        date = Date.strptime( date, '%Y-%m-%d' )   if date.is_a?( String )
        league_key = league.is_a?( String ) ? league : league.key

        years = @leagues[ league_key ]
        if years
            year = years[ date.year ]
            if year
                season_key = nil
                year.each do |event|
                  ##  todo/check: rename/use between? instead of include? - why? why not?
                  if event.include?( date )
                    season_key = event.season.key
                    break
                  end
                end
                if season_key.nil?
                  puts "!! WARN: date >#{date}< out-of-seasons for year #{date.year} in league #{league_key}:"
                  year.each do |event|
                    puts "  #{event.season.key} |  #{event.start_date} - #{event.end_date}"
                  end
                  ## retry again and pick season with "overflow" at the end (date is great end_date)
                  year.each do |event|
                    if date > event.end_date
                      diff_in_days = date.to_date.jd - event.end_date.to_date.jd
                      puts "    +#{diff_in_days} days - adding overflow to #{event.season.key} ending on #{event.end_date} ++ #{date}"
                      season_key = event.season.key
                      break
                    end
                  end
                  ## exit now for sure - if still empty!!!!
                  if season_key.nil?
                    puts "!! ERROR: CANNOT auto-fix / (auto-)append date at the end of an event; check season setup - sorry"
                    exit 1
                  end
                end
                season_key
            else
              nil   ## no year defined / found for league
            end
        else
           nil   ## no league defined / found
        end
    end  # method find

end # class SeasonIndex



EVENTS  = EventIndex.build( "../../../openfootball/leagues" )
SEASONS = SeasonIndex.new( EVENTS )



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

