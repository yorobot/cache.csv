require_relative 'lib/convert'


# Footballdata.config.convert.out_dir = './o'
# '../../stage/one'


['ENG.1',
 'ENG.2',
 'DE.1',
 'ES.1',
 'FR.1',
 'IT.1',
 'NL.1',
 'PT.1',
 'BR.1',   ### note: gets 2020/21 season!! runs until february 2021!!!
].each do |league|
  Footballdata.convert( league: league, year: 2020 )
end

## note: special case converter for champions league now
Footballdata.convert_cl( league: 'CL', year: 2020 )
