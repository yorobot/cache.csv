module Worldfootball

LEAGUES_PACIFIC = {

  # /nzl-nz-football-championship-2019-2020/
  # /nzl-nz-football-championship-2018-2019-playoffs/
  'nz.1' => {
    stages: {
      'regular' => { name: 'Regular Season',   slug: 'nzl-nz-football-championship-{season}' },
      'finals'  => { name: 'Playoff Finals',   slug: 'nzl-nz-football-championship-{season}-playoffs' },
     },
     format: ->( season ) {
      case season
      when Season.new('2019/20')
        %w[regular]   ## covid-19 - no playoffs/finals
      when Season.new('2018/19')
        %w[regular finals]
      else
        puts "!! ERROR - no configuration found for season >#{season}< for NZ1 found; sorry"
        exit 1
      end
     }
  },
}

end # module Worldfootball
