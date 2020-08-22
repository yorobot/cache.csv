#### todo/check: move MODS and SCORE_ERRORS out-of-lib
##               and into config or such - why? why not?


module Worldfootball


######
# "global" helpers
def self.norm_team( team )
   ## clean team name and asciify (e.g. ’->' )
   team = team.sub( '(old)', '' ).strip
   team = team.gsub( '’', "'" )     ## e.g. Hawke’s Bay United FC
   team
end



MODS = {
 'at' => {
    ## AT 1
    'SC Magna Wiener Neustadt' => 'SC Wiener Neustadt', # in 2010/11
    'KSV Superfund'            => 'Kapfenberger SV',    # in 2010/11
    'Kapfenberger SV 1919'     => 'Kapfenberger SV',    # in 2011/12
    'FC Trenkwalder Admira'    => 'FC Admira Wacker',    # in 2011/12
    ## AT 2
    'Austria Wien (A)'         => 'Young Violets',  # in 2019/20
    'FC Wacker Innsbruck (A)'  => 'FC Wacker Innsbruck II',   # in 2018/19
    ## AT CUP
    'Rapid Wien (A)'           => 'Rapid Wien II',  # in 2011/12
    'Sturm Graz (A)'           => 'Sturm Graz II',
    'Kapfenberger SV 1919 (A)' => 'Kapfenberger SV II',
    'SV Grödig (A)'            => 'SV Grödig II',
    'FC Trenkwalder Admira (A)' => 'FC Admira Wacker II',
    'RB Salzburg (A)'          => 'RB Salzburg II',
    'SR WGFM Donaufeld'        => 'SR Donaufeld Wien',
  },
 'nz' => {
    ## NZ 1
   'Wellington Phoenix (R)' => 'Wellington Phoenix Reserves',
  },
}



## fix/patch known score format errors in at/de cups
SCORE_ERRORS = {
  #  '0-1 (0-0, 0-0, 0-0) n.V.' => '0-1 (0-0, 0-0) n.V.',       # too long
  #  '2-1 (1-1, 1-1, 1-0) n.V.' => '2-1 (1-1, 1-1) n.V.',
  #  '4-2 (0-0, 0-0) i.E.'      => '4-2 (0-0, 0-0, 0-0) i.E.',  # too short
}


end # module Worldfootball
