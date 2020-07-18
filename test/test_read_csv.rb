require_relative '../boot'


path = "../../stage/one/2019-20/fr.1.csv"
matches = SportDb::CsvMatchParser.read( path )

pp matches[-1]
