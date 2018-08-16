require 'normalize_csv/output'
require 'normalize_csv/row'

RSpec.describe NormalizeCsv::Output do
  describe '#csv_header' do
    it 'returns string csv header row' do
      expect(NormalizeCsv::Output.csv_header).to eq("Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes\n")
    end
  end
  describe '#csv_row' do
    let(:row) do
      NormalizeCsv::Row.new(
        timestamp: Time.new(2011,4,1,11,0,0, "-07:00").in_time_zone('US/Pacific'),
        address: '123 4th ☃  St, Anywhere, AA',
        zip: 94121,
        full_name: 'Monkey 🐵 Alberto',
        foo_duration: 3723.123,
        bar_duration: 3725.123,
        notes: 'I am the very model of a modern major general ⚑'
      )
    end

    it 'includes formatted timestamp' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('2011-04-01T14:00:00-04:00')
    end

    it 'includes address' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('123 4th ☃  St, Anywhere, AA')
    end

    it 'includes formatted zip' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('94121')
    end

    describe 'with short zip' do
      let(:row) do
        NormalizeCsv::Row.new(
          timestamp: Time.new(2011,4,1,11,0,0, "-07:00").in_time_zone('US/Pacific'),
          address: '123 4th ☃  St, Anywhere, AA',
          zip: 121,
          full_name: 'Monkey 🐵 Alberto',
          foo_duration: 3723.123,
          bar_duration: 3723.123,
          notes: 'I am the very model of a modern major general ⚑'
        )
      end

      it 'includes formatted zip' do
        expect(NormalizeCsv::Output.csv_row(row)).
          to include('00121')
      end
    end

    it 'includes uppercased name' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('MONKEY 🐵 ALBERTO')
    end

    describe 'with non english name' do
      let(:row) do
        NormalizeCsv::Row.new(
          timestamp: Time.new(2011,4,1,11,0,0, "-07:00").in_time_zone('US/Pacific'),
          address: '123 4th ☃  St, Anywhere, AA',
          zip: 94121,
          full_name: '株式会社スタジオジブリ',
          foo_duration: 3723.123,
          bar_duration: 3725.123,
          notes: 'I am the very model of a modern major general ⚑'
        )
      end

      it 'includes name' do
        expect(NormalizeCsv::Output.csv_row(row)).
          to include('株式会社スタジオジブリ')
      end
    end

    it 'includes foo duration' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('3723.123')
    end

    it 'includes bar duration' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('3725.123')
    end

    it 'includes total duration' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('7448.246')
    end

    it 'includes notes' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to include('I am the very model of a modern major general ⚑')
    end

    it 'produces the right order' do
      expect(NormalizeCsv::Output.csv_row(row)).
        to eq("2011-04-01T14:00:00-04:00,\"123 4th ☃  St, Anywhere, AA\",94121,MONKEY 🐵 ALBERTO,3723.123,3725.123,7448.246,I am the very model of a modern major general ⚑\n")
    end
  end
end
