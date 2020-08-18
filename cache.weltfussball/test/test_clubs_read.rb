require_relative '../lib/convert'


Club = Sports::Club

recs = Club.parse( <<TXT )
= Austria =

Rapid Wien
Austria Wien
TXT

pp recs


__END__

puts
puts "---"

recs = SportDb::Import::ClubReader.parse( <<TXT )
= Austria =

Rapid Wien
Austria Wien
TXT

pp recs


