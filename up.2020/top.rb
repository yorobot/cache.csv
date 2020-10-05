require_relative 'helper'


## top-level countries / leagues

DATASETS = [
 ['br.1',    %w[2020]],     # starts Sun Aug 9  - note: now runs into 2021!!!

 ['eng.1',   %w[2020/21]],   # starts Sat Sep 12
 ['eng.2',   %w[2020/21]],   # starts Sat Sep 12
 ['eng.3',   %w[2020/21]],   # starts Sat Sep 12
 ['eng.4',   %w[2020/21]],   # starts Sat Sep 12
 ['eng.5',   %w[2020/21]],   # starts Sat Oct 3
 ## todo/fix: add league cup and ...

 ['de.1',    %w[2020/21]],   # starts Fri Sep 18
 ['de.2',    %w[2020/21]],   # starts Fri Sep 18
 ['de.3',    %w[2020/21]],   # starts Fri Sep 18
 ['de.cup',  %w[2020/21]],

 ['es.1',    %w[2020/21]],   # starts Fri Sep 11
 ['es.2',    %w[2020/21]],   # starts Fri Sep 11

 ['fr.1',    %w[2020/21]],   # starts Fri Aug 21
 ['fr.2',    %w[2020/21]],   # starts Sat Aug 22

 ['it.1',    %w[2020/21]],   # starts Sun Sep 20
 ['it.2',    %w[2020/21]],   # starts Fri Sep 25


 ['at.1',    %w[2020/21]],   # starts Fri Sep 11
 ['at.2',    %w[2020/21]],   # starts Fri Sep 11
 ['at.3.o',  %w[2020/21]],   # starts Fri Aug 21
 ['at.cup',  %w[2020/21]],   # starts Fri Aug 28


 ['mx.1',    %w[2020/21]],   # starts Fri Jul 24
]

pp DATASETS



if ARGV.empty?
  REPOS    = [
              'england',
              'deutschland',
              'austria',
              'france',
              'italy',
              'espana',
              'mexico',
              'brazil',
             ]
else
  leagues = []
  repos = []
  ARGV.each do |q|   ## find all matching leagues (that is, league keys)
    more_leagues = DATASETS
                     .map { |dataset| dataset[0] }
                     .find_all {|league| league.start_with?(q.downcase) }
    leagues += more_leagues  if more_leagues
  end

  leagues.each do |league|
    league_info = Writer::LEAGUES[ league ]
    pp league_info
    path = league_info[:path]

    ## use only first part e.g. world/europe/belgium => world
    repos << path.split( %r{[/\\]})[0]
  end

  repos
  pp repos
  REPOS = repos.uniq
  pp REPOS
end




process( DATASETS,
         REPOS,
         includes: ARGV
       )

puts "bye"

