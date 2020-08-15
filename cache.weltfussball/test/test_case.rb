require 'pp'


### Q: check for unmatched case without else branch in case
###   what gets returned - nil?
##  A: yes, nil gets returned

##
##  note: when 11: 'XI'  no longer works (syntax error - deprecated old syntax before 1.9)

def roman(n)
  case n
  when (1..4) then 'I'*n
  when 11     then 'XI'
  when 12; 'XII'
  end
end

pp roman(1)
puts roman(1).class.name

pp roman(4)
puts roman(4).class.name

pp roman(11)
puts roman(11).class.name

pp roman(10)
puts roman(10).class.name