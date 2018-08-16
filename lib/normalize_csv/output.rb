require 'csv'
require 'time'
require 'active_support/time'

module NormalizeCsv
  module Output
    def self.csv_header
      %w[Timestamp Address ZIP FullName FooDuration BarDuration TotalDuration Notes].to_csv
    end

    def self.csv_row(row)
      [
        format_timestamp(row.timestamp),
        row.address,
        format_zip(row.zip),
        format_full_name(row.full_name),
        row.foo_duration,
        row.bar_duration,
        total_duration(row.foo_duration, row.bar_duration),
        row.notes
      ].to_csv
    end

    private

    def self.format_timestamp(timestamp)
      timestamp.in_time_zone('US/Eastern').iso8601
    end

    def self.format_zip(zip)
      zip.to_s.rjust(5, '0')
    end

    def self.format_full_name(full_name)
      full_name.upcase
    end

    def self.total_duration(foo_duration, bar_duration)
      foo_duration + bar_duration
    end
  end
end
