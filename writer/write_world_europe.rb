start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


require_relative './write_utils'


boot_time = Time.now



def write_is( season, source: )
  write_worker( 'is.1', season, source: source )
end

def write_ie( season, source: )
  write_worker( 'ie.1', season, source: source )
end


STAGES_FI = [['Regular Season'],
             ['Playoffs - Championship',
              'Playoffs - Challenger',
              'Europa League Finals' ]]

def write_fi( season, source: )
  write_worker_with_stages( 'fi.1', season, source: source, stages: STAGES_FI )
end



# is.1 - 2 seasons (2019 2020)
write_is( '2019',  source: 'two/o' )
write_is( '2020',  source: 'two/o' )

# ie.1 - 2 seasons (2019 2020)
write_ie( '2019',  source: 'two/o' )
write_ie( '2020',  source: 'two/o' )


# fi.1 - 2 seasons (2019 2020)
write_fi( '2019',  source: 'two/o' )
write_fi( '2020',  source: 'two/o' )





end_time = Time.now
print "write_world_europe: done in #{end_time - start_time} sec(s); "
print "boot in #{boot_time - start_time} sec(s)"
print "\n"

puts "bye"
