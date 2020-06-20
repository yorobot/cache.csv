require 'date'
require 'pp'


## todo/check: use ruby ranges for date periods - why? why not?

start_date = Date.new( 2018, 7, 1 )
end_date   = Date.new( 2019, 6, 30 )

range = start_date..end_date

pp range
pp range.begin
pp range.end

pp range.include?( Date.new( 2018, 12, 1 ))  #=> true
pp range.include?( Date.new( 2019, 12, 1 ))  #=> false

