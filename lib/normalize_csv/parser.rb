# frozen_string_literal: true

require 'csv'
require 'time'
require 'active_support/time'
require 'normalize_csv/row'

module NormalizeCsv
  module Parser
    class << self
      def parse(csv_line)
        CSV.parse(csv_line) do |row|
          return create_row(row)
        end
      rescue StandardError
        STDERR.puts "Warning: skipping row. Invalid data detected '#{csv_line}'."
      end

      private

      def create_row(row)
        Row.new(
          timestamp: parse_timestamp(row[0]),
          address: parse_address(row[1]),
          zip: parse_zip(row[2]),
          full_name: parse_full_name(row[3]),
          foo_duration: parse_duration(row[4]),
          bar_duration: parse_duration(row[5]),
          notes: parse_notes(row[7])
        )
      end

      def sanitize_utf8(string)
        string&.encode('UTF-8', invalid: :replace, undef: :replace)
      end

      def parse_timestamp(timestamp)
        ENV['TZ'] = 'US/Pacific'
        Time.strptime(sanitize_utf8(timestamp), '%m/%d/%y %l:%M:%S %p').in_time_zone('US/Pacific')
      end

      def parse_address(address)
        sanitize_utf8(address)
      end

      def parse_zip(zip)
        sanitize_utf8(zip).to_i
      end

      def parse_full_name(full_name)
        sanitize_utf8(full_name)
      end

      def parse_duration(duration)
        matches = /(?<hours>\d\d?):(?<minutes>\d\d?):(?<seconds>\d\d?).(?<milliseconds>\d+)/
                  .match(sanitize_utf8(duration))

        hours_to_seconds(matches[:hours]) +
          minutes_to_seconds(matches[:minutes]) +
          matches[:seconds].to_i +
          milliseconds_to_seconds(matches[:milliseconds])
      end

      def hours_to_seconds(hours)
        hours.to_i * 60 * 60
      end

      def minutes_to_seconds(minutes)
        minutes.to_i * 60
      end

      def milliseconds_to_seconds(milliseconds)
        milliseconds.to_i * 0.001
      end

      def parse_notes(notes)
        sanitize_utf8(notes)
      end
    end
  end
end
