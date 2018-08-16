require 'csv'
require 'time'
require 'active_support/time'

module NormalizeCsv
  module Parser
    def self.parse(csv_line)
      CSV.parse(csv_line) do |row|
        return Row.new(
          timestamp: parse_timestamp(row[0]),
          address: parse_address(row[1]),
          zip: parse_zip(row[2]),
          full_name: parse_full_name(row[3]),
          foo_duration: parse_duration(row[4]),
          bar_duration: parse_duration(row[5]),
          notes: parse_notes(row[7])
        )
      end
    rescue
      STDERR.puts "Warning: skipping row. Invalid data detected '#{csv_line}'."
    end

    private

    def self.sanitize_utf8(string)
      string.encode('UTF-8', invalid: :replace, undef: :replace)
    end

    def self.parse_timestamp(timestamp)
      ENV['TZ'] = 'US/Pacific'
      Time.strptime(sanitize_utf8(timestamp), '%m/%d/%y %I:%M:%S %p').in_time_zone('US/Pacific')
    end

    def self.parse_address(address)
      sanitize_utf8(address)
    end

    def self.parse_zip(zip)
      sanitize_utf8(zip).to_i
    end

    def self.parse_full_name(full_name)
      sanitize_utf8(full_name)
    end

    def self.parse_duration(duration)
      matches = /(?<hours>\d\d?):(?<minutes>\d\d?):(?<seconds>\d\d?).(?<milliseconds>\d+)/.match(sanitize_utf8(duration))

      duration = (matches[:hours].to_i * 60 * 60) +
        (matches[:minutes].to_i * 60) +
        matches[:seconds].to_i +
        (matches[:milliseconds].to_i * 0.001)
    end

    def self.parse_notes(notes)
      sanitize_utf8(notes)
    end
  end
end
