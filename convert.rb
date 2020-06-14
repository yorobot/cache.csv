require_relative 'boot'



def convert( *country_keys, out_dir:, start: nil )

  FOOTBALLDATA_SOURCES.each do |country_key, country_sources|
      Footballdata.convert_season_by_season( country_key, country_sources,
                              in_dir: './dl',
                              out_dir: out_dir,
                              start: start )     if country_keys.empty? || country_keys.include?( country_key )
  end

  FOOTBALLDATA_SOURCES_II.each do |country_key, country_basename|
    Footballdata.convert_all_seasons( country_key, country_basename,
                            in_dir: './dl',
                            out_dir: out_dir,
                            start: start )   if country_keys.empty? || country_keys.include?( country_key )
  end

end  # method convert



# OUT_DIR = "./o"
OUT_DIR = "../../footballcsv/cache.footballdata"

convert( out_dir: OUT_DIR )

# convert( :eng, out_dir: OUT_DIR )
# convert( :eng, out_dir: OUT_DIR, start: '2018/19' )

# convert( :at, out_dir: OUT_DIR, start: '2018/19' )
# convert( :mx, out_dir: OUT_DIR )


puts "bye"