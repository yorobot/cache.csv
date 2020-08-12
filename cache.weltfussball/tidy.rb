
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


## class="hell"
## align="center"

CLASS_RE = %r{ \bclass="
                      (?:hell|dunkel)
                       "
             }x

ALIGN_RE  = %r{ \balign="
                       (?:center|right)
                        "
              }x



pages = Dir.glob( './dl2/*' )

puts "#{pages.size} pages"
puts

pages.each do |page|
   basename = File.basename( page, File.extname( page ) )
   print "  #{basename}"

   html = File.open( page, 'r:utf-8' ) {|f| f.read }

   html, scripts = strip_scripts( html )

   html = html.gsub( CLASS_RE, '' )
   html = html.gsub( ALIGN_RE, '' )
   html = html.gsub( /<td[ ]+>/, '<td>' ) ## tidy up tds with trailing spaces left overs too

   File.open( page, 'w:utf-8' ) {|f| f.write( html ) }
end
