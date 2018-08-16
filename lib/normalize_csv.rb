require 'normalize_csv/version'
require 'normalize_csv/parser'
require 'normalize_csv/output'

module NormalizeCsv
  def self.process
    STDIN.each_line do |line|
      if line.strip == "Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes"
        STDOUT.puts NormalizeCsv::Output.csv_header
      else
        parsed_row = NormalizeCsv::Parser.parse(line.strip)
        STDOUT.puts NormalizeCsv::Output.csv_row(parsed_row) unless parsed_row.nil?
      end
    end
  end
end
