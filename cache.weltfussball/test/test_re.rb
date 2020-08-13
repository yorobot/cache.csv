require 'pp'

str = 'Andrés Andrade 88.  (Nicolas Meister)'
str = str.gsub( "\u{00A0}", ' ' )  # Unicode Character 'NO-BREAK SPACE' (U+00A0)

m = %r{^([^0-9]+)
         [ ]+
         ([0-9]+)\.
        (?:
         [ ]+
         (\([^)]+\))
        )?
    $}x.match( str )
pp m

