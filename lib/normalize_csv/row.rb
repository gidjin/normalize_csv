# frozen_string_literal: true

# Class represents data from a parsed row of csv input
module NormalizeCsv
  class Row
    attr_reader :timestamp
    attr_reader :address
    attr_reader :zip
    attr_reader :full_name
    attr_reader :foo_duration
    attr_reader :bar_duration
    attr_reader :notes

    def initialize(arguments)
      @timestamp = arguments[:timestamp]
      @address = arguments[:address]
      @zip = arguments[:zip]
      @full_name = arguments[:full_name]
      @foo_duration = arguments[:foo_duration]
      @bar_duration = arguments[:bar_duration]
      @notes = arguments[:notes]
    end
  end
end
