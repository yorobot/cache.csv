require_relative '../boot'


path = "./o/cl/2019-20/cl_test.csv"
matches = SportDb::CsvMatchParser.read( path )

pp matches[0]
puts "#{matches.size} matches"


__END__

#<SportDb::Import::Match:0x47604f0
 @date="2019-06-25",
 @league=nil,
 @round=nil,
 @score1=0,
 @score1i=0,
 @score2=1,
 @score2i=0,
 @stage="Qualifying",
 @team1="SP Tre Penne",
 @team2="FC Santa Coloma",
 @winner=2>


Stage,Round,Group,Date,Team 1,FT,HT,Team 2,ET,P,Comments
Group,Matchday 1,F,Tue Sep 17 2019,FC Internazionale Milano,1-1,0-0,SK Slavia Praha,2-2,3-3,

 #<SportDb::Import::Match:0x4d6a588
 @date="2019-09-17",
 @league=nil,
 @round=nil,
 @score1=1,
 @score1i=0,
 @score2=1,
 @score2i=0,
 @stage="Group",
 @team1="FC Internazionale Milano",
 @team2="SK Slavia Praha",
 @winner=0>