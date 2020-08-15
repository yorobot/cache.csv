
require_relative '../lib/metal'

require_relative '../../csv'


## get all reports for a (schedule) page
path = './dl/at.2-2019-20.html'
# path = './dl/at.1-2014-15.html'
# path = './dl/at.1-2016-17.html'

page = Worldfootball::Page::Schedule.from_file( path )
rows = page.matches

puts "matches - #{rows.size} rows:"
pp rows[0]

puts page.generated


recs = []
matches_count = page.matches.size
page.matches.each_with_index do |match,i|

  path_report = "./dl2/#{match[:report]}.html"
  puts "reading #{i+1}/#{matches_count} - #{match[:report]}..."
  report = Worldfootball::Page::Report.from_file( path_report )

  puts
  puts report.title
  puts report.generated

  rows = report.goals
  puts "goals - #{rows.size} records"
  pp rows


  if rows.size > 0
    ## add goals
    date = Date.strptime( match[:date], '%Y-%m-%d')
    match_id = "#{match[:team1][:text]} - #{match[:team2][:text]} | #{date.strftime('%b %-d')}"


    rows.each do |row|
      extra = if row[:owngoal]
                '(og)'
              elsif row[:penalty]
                '(pen)'
              else
                ''
              end

      rec = [match_id,
             row[:score],
             "#{row[:minute]}'",
             extra,
             row[:name],
             row[:notes]]
      recs << rec
    end
  end
end

## pp recs

# out_path = "./tmp/goals.at.2016-17.csv"
out_path = "./tmp/goals.csv"

headers  = ['Match', 'Score', 'Minute', 'Extra', 'Player', 'Notes']

puts "write #{out_path}..."
Cache::CsvMatchWriter.write( out_path, recs, headers: headers )


puts "bye"
