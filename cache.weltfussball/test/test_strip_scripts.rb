require 'pp'


## note: might start with an optional comment
SCRIPT_RE = %r{ (?:
                   <!-- [ ]+
                 )?
               <script[^>]*>
                 .*?
               <\/script>
                (?:
                 [ ]+ -->
                )?
               }imx

def strip_scripts( html )
  buf = String.new('')
  i=0
  html = html.gsub( SCRIPT_RE  ) do |match|
     i+=1
     buf << "<!-- script #{i} -->\n"
     buf << match
     buf << "\n\n"
     pp match
      "<!-- CUT SCRIPT #{i} -->"
  end

  [html, buf]
end


# path = './dl/at.1-2010-11.html'
path = './dl2/bundesliga-2019-2020-rapid-wien-rb-salzburg.html'

html =  File.open( path, 'r:utf-8' ) { |f| f.read }

html, scripts = strip_scripts( html )

File.open( './tmp/page2.html', 'w:utf-8' ) { |f| f.write( html ) }
File.open( './tmp/scripts2.html', 'w:utf-8' ) { |f| f.write( scripts ) }

puts "bye"