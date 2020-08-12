start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?


require_relative './write_utils'


boot_time = Time.now



DATAFILES = [
  ['is.1',   %w[2020    2019]],
  ['sco.1',  %w[2020/21 2019/20 2018/19]],
  ['ie.1',   %w[2020    2019]],
  ['fi.1',   %w[2020    2019]],
  ['se.1',   %w[2020    2019]],
  ['se.2',   %w[2020    2019]],
  ['no.1',   %w[2020    2019]],
  ['dk.1',   %w[2020/21 2019/20 2018/19]],
  ['sk.1',   %w[2020/21 2019/20 2018/19]],
  ['pl.1',   %w[2020/21 2019/20 2018/19]],
  ['hr.1',   %w[2020/21 2019/20 2018/19]],
  ['be.1',   %w[2020/21 2019/20 2018/19]],
  ['nl.1',   %w[2020/21]],
  ['lu.1',   %w[2020/21 2019/20 2018/19]],
  ['ua.1',   %w[        2019/20 2018/19]],
]

pp DATAFILES

DATAFILES.each do |datafile|
  league = datafile[0]
  datafile[1].each do |season|
    write_worker( league, season, source: 'two/o' )
  end
end


end_time = Time.now
print "write_world_europe: done in #{end_time - start_time} sec(s); "
print "boot in #{boot_time - start_time} sec(s)"
print "\n"

puts "bye"
