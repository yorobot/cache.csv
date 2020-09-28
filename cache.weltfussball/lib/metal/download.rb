

module Worldfootball




## todo/check: put in Downloader namespace/class - why? why not?
##   or use Metal    - no "porcelain" downloaders / machinery
class Metal
  def self.worker
      @worker ||= Fetcher::Worker.new
  end

  def self.config() Worldfootball.config;  end   ## reuse/forward config


  BASE_URL = 'https://www.weltfussball.de'



  # def self.report_path( slug )  ## change to report_local_path or mk_report_path or such??
  #  "#{config.cache.reports_dir}/#{slug}.html"
  # end

  # def self.report?( slug )
  #  File.exist?( report_path( slug ) )
  # end


  def self.report( slug, cache: true )
    url  = "#{BASE_URL}/spielbericht/#{slug}/"

    out_path = "#{config.cache.reports_dir}/#{slug}.html"

    ## check check first
    if cache && File.exist?( out_path )
       puts "  reuse local copy (#{out_path})"
    else
      copy( url, out_path )
    end
  end

  def self.schedule( slug )
    url  = "#{BASE_URL}/alle_spiele/#{slug}/"

    out_path = "#{config.cache.schedules_dir}/#{slug}.html"
    copy( url, out_path  )
  end


  def self.schedule_reports( slug, cache: true ) ## todo/check: rename to reports_for_schedule or such - why? why not?

    page = Page::Schedule.from_cache( slug )
    matches = page.matches

    puts "matches - #{matches.size} rows:"
    pp matches[0]

    puts "#{page.generated_in_days_ago}  - #{page.generated}"

    ## todo/fix: restore sleep to old value at the end!!!!
    config.sleep = 8    ## fetch 7-8 pages/min

    matches.each_with_index do |match,i|
       est = (config.sleep * (matches.size-(i+1)))/60.0   # estimated time left

       puts "fetching #{i+1}/#{matches.size} (#{est} min(s)) - #{match[:round]} | #{match[:team1]} v #{match[:team2]}..."
       report_ref = match[:report_ref ]
       if report_ref
         report( report_ref, cache: cache )
       else
         puts "!! WARN: report ref missing for match:"
         pp match
       end
    end
  end



  ##################
  #  helpers

  def self.copy( url, path )  ## copy (save) to file

    puts "  sleep #{config.sleep} sec(s)..."
    sleep( config.sleep )   ## slow down - sleep 2secs before each http request

    response = worker.get( url )

    if response.code == '200'
      html = response.body.to_s
      html = html.force_encoding( Encoding::UTF_8 )

      FileUtils.mkdir_p( File.dirname(path) )
      File.open( path, 'w:utf-8' ) {|f| f.write( html ) }
    else
      puts "!! ERROR - #{response.code}:"
      pp response
      exit 1
    end
  end

end # class Metal
end # module Worldfootball


