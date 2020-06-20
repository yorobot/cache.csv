require_relative '../boot'



class SeasonIndex
    class SeasonInfo   # nested (inner) class
        def initialize( season, start_date: nil, end_date: nil )
           @season      = season
           @start_date  = start_date
           @end_date    = end_date
        end

        ### note: returns path/directory for now e.g. 2019-20 and NOT 2019/20
        def key()  @season.directory; end

        def include?( date )
            ### note: for now allow off by one error (via timezone/local time errors)
            ##    todo/fix: issue warning if off by one!!!!
           if @start_date && @end_date
              date >= (@start_date-1) &&
              date <= (@end_date+1)
           else
              if @season.year?
                 true # assume same year; always true
              else
                 date >= Date.new( @season.start_year, 7, 1 ) &&
                 date <= Date.new( @season.end_year, 6, 30 )
              end
           end
        end
     end # nested (inner) class SeasonInfo



     def self.build( path )
        datafiles = SportDb::Package.find_seasons( path )

        puts
        puts "#{datafiles.size} seasons datafile(s):"
        pp datafiles


        leagues = {}   ## known seasons for leagues

        datafiles.each do |datafile|
          CsvHash.foreach( datafile, :header_converters => :symbol  ) do |row|
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


            season_info = SeasonInfo.new( season, start_date: dates[0],
                                                  end_date:   dates[1] )

            years = leagues[ league.key ] ||= {}
            if season.year?
              years[season.start_year] ||= []
              years[season.start_year] << season_info
            else
              years[season.start_year] ||= []
              years[season.end_year]   ||= []
              years[season.start_year] << season_info
              years[season.end_year]   << season_info
            end

          end  # each row
        end    # each datafile

        new( leagues )
     end


     def initialize( leagues )
        @leagues = leagues   ## use a league hash by years for now; change later
        pp @leagues
     end


     def find( date, league: )
        league_key = league.is_a?( String ) ? league : league.key

        years = @leagues[ league_key ]
        if years
            year = years[ date.year ]
            if year
                season_key = nil
                year.each do |season|
                  if season.include?( date )
                    season_key = season.key
                    break
                  end
                end
                if season_key.nil?
                  puts "!! WARN: date out-of-seasons for year #{date.year} in league #{league_key}:"
                  pp date
                  pp year
                  ## exit 1
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




SEASONS = SeasonIndex.build( "../../../openfootball/leagues" )


def date_to_season( date, league: )
  season_key = SEASONS.find( date, league: league )
  if season_key.nil?
      start_year =  if date.month >= 7
                        date.year
                    else
                        date.year-1
                    end

     season_key = '%4d-%02d' % [start_year, (start_year+1)%100]
  end
  season_key
end



if __FILE__ == $0
  pp date_to_season( Date.new( 2018, 5, 4 ),  league: 'br.1' )
  pp date_to_season( Date.today,              league: 'br.1' )

  pp date_to_season( Date.new( 2018, 5, 4 ),  league: 'ar.1' )
  pp date_to_season( Date.new( 2020, 3, 9 ),  league: 'ar.1' )

  pp date_to_season( Date.new( 2014, 5, 24 ), league: 'ar.1' )
  pp date_to_season( Date.new( 2014, 8, 8 ),  league: 'ar.1' )

  puts "bye"
end

