

module Worldfootball

  def self.worker
    @worker ||= Fetcher::Worker.new
  end


  BASE_URL = 'https://www.weltfussball.de'


  def self.report_path( slug )  ## change to report_local_path or mk_report_path or such??
    "./dl2/#{slug}.html"
  end

  def self.report?( slug )
    File.exist?( report_path( slug ) )
  end

  def self.report( slug, cache: true )
    url  = "#{BASE_URL}/spielbericht/#{slug}/"

    out_path = report_path( slug )

    ## check check first
    if cache && File.exist?( out_path )
       puts "  reuse local copy (#{out_path})"
    else
      copy( url, out_path )
    end
  end



  def self.copy( url, path )  ## copy (save) to file

    puts "  sleep #{config.sleep} sec(s)..."
    sleep( config.sleep )   ## slow down - sleep 2secs before each http request

    response = worker.get( url )

    if response.code == '200'
      html = response.body.to_s
      html = html.force_encoding( Encoding::UTF_8 )

      File.open( path, 'w:utf-8' ) {|f| f.write( html ) }
    else
      puts "!! ERROR - #{response.code}:"
      pp response
      exit 1
    end
  end


end # module Worldfootball


