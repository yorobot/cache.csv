require 'fetcher'


module Worldfootball

  def self.worker
    @worker ||= Fetcher::Worker.new
  end

  BASE_URL = 'https://www.weltfussball.de/spielbericht'

  def self.report( slug )

    url  = "#{BASE_URL}/#{slug}/"

    copy( url, "./dl2/#{slug}.html" )
  end


  def self.copy( url, path )  ## copy (save) to file
    sleep( 2 )   ## slow down - sleep 2secs before each http request

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


# https://www.weltfussball.de/spielbericht/bundesliga-2019-2020-rapid-wien-rb-salzburg/

# Worldfootball.report( 'bundesliga-2019-2020-rapid-wien-rb-salzburg' )

# https://www.weltfussball.de/spielbericht/bundesliga-2019-2020-skn-st-poelten-sv-mattersburg/
# https://www.weltfussball.de/spielbericht/bundesliga-2019-2020-lask-sv-mattersburg/
# https://www.weltfussball.de/spielbericht/bundesliga-2019-2020-scr-altach-wsg-tirol/
# https://www.weltfussball.de/spielbericht/bundesliga-2019-2020-rapid-wien-rb-salzburg/
# https://www.weltfussball.de/spielbericht/bundesliga-2019-2020-wsg-tirol-austria-wien/

Worldfootball.report( 'bundesliga-2019-2020-skn-st-poelten-sv-mattersburg' )
Worldfootball.report( 'bundesliga-2019-2020-lask-sv-mattersburg' )
Worldfootball.report( 'bundesliga-2019-2020-scr-altach-wsg-tirol' )
Worldfootball.report( 'bundesliga-2019-2020-rapid-wien-rb-salzburg' )
Worldfootball.report( 'bundesliga-2019-2020-wsg-tirol-austria-wien' )

Worldfootball.report( 'oefb-cup-2019-2020-1-runde-sc-wiener-viktoria-tsv-hartberg' )

