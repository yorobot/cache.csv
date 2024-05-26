###
#
# TZInfo is another time zone library, 
## which provides daylight-saving-aware transformations
#  between times in different time zones. 
# It is available as a gem and includes data on 582 different time zones.
#
#  https://tzinfo.github.io/
#  https://rubydoc.info/gems/tzinfo/file/README.md
#   https://thoughtbot.com/blog/its-about-time-zones
#  


require 'tzinfo'

pp TZInfo::Timezone.all_identifiers

__END__

tz_eng  = TZInfo::Timezone.get( 'Europe/London' )
pp tz_eng

tz_de  = TZInfo::Timezone.get( 'Europe/Berlin' )
pp tz_de

tz_es  = TZInfo::Timezone.get( 'Europe/Madrid' )
pp tz_es

tz_it  = TZInfo::Timezone.get( 'Europe/Rome' )
pp tz_it

tz_fr =  TZInfo::Timezone.get( 'Europe/Paris' )
pp tz_fr





utcs = [
 Time.utc( 2021, 5, 5, 12, 00, 0),
 Time.utc( 2021, 1, 1, 12, 00, 0),
 Time.utc( 2021, 12, 1, 12, 00, 0),
 Time.utc( 2021, 5, 5, 12, 00),
 Time.utc( 2021, 1, 1, 12, 00),
 Time.utc( 2021, 12, 1, 12, 00),
]

utcs.each do |utc|
 ## check for summer time ??

  local = tz_eng.to_local(  utc )
  pp local
  pp local.utc_offset  
  pp local.dst?   
  pp local.zone       

  puts local.strftime( '%Y-%m-%d' )
  puts local.strftime( '%H:%M' )
  puts local.strftime( '%Z/UTC%z') 


  puts
  local = tz_de.to_local(  utc )
  pp local
  pp local.utc_offset     # e.g => 3600 (in secs e.g.+01:00)
  puts local.utc_offset.class.name  
  pp local.dst?   
  pp local.zone    
  puts local.zone.class.name 
  puts local.class.name    ## TZInfo::TimeWithOffset

  puts local.strftime( '%Y-%m-%d' )
  puts local.strftime( '%H:%M' )
  puts local.strftime( '%Z/UTC%z') 


end

##  GMT =  Greenwich Mean Time
##  BST =  British Summer Time  (is UTC+01)
##  CET  =  Central European Time (is UTC+01)
##  CEST = Central European Summer Time (CEST is UTC+02)


# 2021-05-05 13:00:00 +0100    - knows about summer time!!
# 2021-01-01 12:00:00 +0000
# 2021-12-01 12:00:00 +0000



__END__

require 'active_support/all'


pp ActiveSupport::TimeZone.all 


puts
pp Time.zone   #=> nil


__END__
puts "---"
TZInfo::Country.all.sort_by { |c| c.name }.each do |c|
    puts c.name # E.g. Norway
    c.zones.each do |z|
        # E.g. Oslo (Europe/Oslo)
      puts "\t#{z.friendly_identifier(true)} (#{z.identifier})" 
    end
  end

puts "bye"


__END__

The IANA time zone database contains 3 zones for Spain. 
Columns marked with * are from the file zone.tab from the database.

c.c.*	coordinates*	TZ*	comments*	UTC offset	Notes
- ES		Europe/Madrid	Spain (mainland) and Balearic Islands	+01:00		
- ES		Africa/Ceuta	Ceuta, Melilla, plazas de soberanía	    +01:00		
- ES		Atlantic/Canary	Canary Islands


France
        Paris (Europe/Paris)

Germany
        Berlin (Europe/Berlin)

Italy
        Rome (Europe/Rome)

Spain
        Madrid (Europe/Madrid)
        Ceuta (Africa/Ceuta)
        Canary (Atlantic/Canary)

Britain (UK)
        London (Europe/London)


"Atlantic/Azores",
 "Atlantic/Bermuda",
 "Atlantic/Canary",  !!!!!
 "Atlantic/Cape_Verde",
 "Atlantic/Faeroe",
 "Atlantic/Faroe",
 "Atlantic/Jan_Mayen",
 "Atlantic/Madeira",  !!!!!
 "Atlantic/Reykjavik",
 "Atlantic/South_Georgia",
 "Atlantic/St_Helena",
 "Atlantic/Stanley",

 "Europe/Amsterdam",
 "Europe/Andorra",
 "Europe/Astrakhan",
 "Europe/Athens",
 "Europe/Belfast",
 "Europe/Belgrade",
 "Europe/Berlin",
 "Europe/Bratislava",
 "Europe/Brussels",
 "Europe/Bucharest",
 "Europe/Budapest",
 "Europe/Busingen",
 "Europe/Chisinau",
 "Europe/Copenhagen",
 "Europe/Dublin",
 "Europe/Gibraltar",
 "Europe/Guernsey",
 "Europe/Helsinki",
 "Europe/Isle_of_Man",
 "Europe/Istanbul",
 "Europe/Jersey",
 "Europe/Kaliningrad",
 "Europe/Kiev",
 "Europe/Kirov",
 "Europe/Kyiv",
 "Europe/Lisbon",
 "Europe/Ljubljana",
 "Europe/London",
 "Europe/Luxembourg",
 "Europe/Madrid",
 "Europe/Malta",
 "Europe/Mariehamn",
 "Europe/Minsk",
 "Europe/Monaco",
 "Europe/Moscow",
 "Europe/Nicosia",
 "Europe/Oslo",
 "Europe/Paris",
 "Europe/Podgorica",
 "Europe/Prague",
 "Europe/Riga",
 "Europe/Rome",
 "Europe/Samara",
 "Europe/San_Marino",
 "Europe/Sarajevo",
 "Europe/Saratov",
 "Europe/Simferopol",
 "Europe/Skopje",
 "Europe/Sofia",
 "Europe/Stockholm",
 "Europe/Tallinn",
 "Europe/Tirane",
 "Europe/Tiraspol",
 "Europe/Ulyanovsk",
 "Europe/Uzhgorod",
 "Europe/Vaduz",
 "Europe/Vatican",
 "Europe/Vienna",
 "Europe/Vilnius",
 "Europe/Volgograd",
 "Europe/Warsaw",
 "Europe/Zagreb",
 "Europe/Zaporozhye",
 "Europe/Zurich",