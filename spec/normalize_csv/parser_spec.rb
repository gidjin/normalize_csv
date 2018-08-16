require 'normalize_csv/parser'
require 'normalize_csv/row'

RSpec.describe NormalizeCsv::Parser do
  describe '#parse' do
    describe 'with plain ascii string' do
      let(:csv_line) { '4/1/11 11:00:00 AM,"123 4th St, Anywhere, AA",94121,Monkey Alberto,1:2:3.123,1:2:3.123,zzsasdfa,I am the very model of a modern major general' }
      let(:expected_row) do
        NormalizeCsv::Row.new(
          timestamp: Time.new(2011,4,1,11,0,0, "-07:00").in_time_zone('US/Pacific'),
          address: '123 4th St, Anywhere, AA',
          zip: 94121,
          full_name: 'Monkey Alberto',
          foo_duration: 3723.123,
          bar_duration: 3723.123,
          notes: 'I am the very model of a modern major general'
        )
      end
      let(:result) { NormalizeCsv::Parser.parse(csv_line) }

      it 'returns row object' do
        expect(result).to be_a_kind_of(NormalizeCsv::Row)
      end

      it 'with correct timestamp' do
        expect(result.timestamp).to eq(expected_row.timestamp)
      end

      it 'with correct address' do
        expect(result.address).to eq(expected_row.address)
      end

      it 'with correct zip' do
        expect(result.zip).to eq(expected_row.zip)
      end

      it 'with correct full_name' do
        expect(result.full_name).to eq(expected_row.full_name)
      end

      it 'with correct foo_duration' do
        expect(result.foo_duration).to eq(expected_row.foo_duration)
      end

      it 'with correct bar_duration' do
        expect(result.bar_duration).to eq(expected_row.bar_duration)
      end

      it 'with correct notes' do
        expect(result.notes).to eq(expected_row.notes)
      end
    end

    describe 'with bad data' do
      let(:bad_duration) { '4/1/11 11:00:00 AM,"123 4th St, Anywhere, AA",94121,Monkey Alberto,a:2:3.123,1:2:3.123,zzsasdfa,I am the very model of a modern major general' }
      let(:bad_date) { '4/1/ya11 11:00:00 AM,"123 4th St, Anywhere, AA",94121,Monkey Alberto,1:2:3.123,1:2:3.123,zzsasdfa,I am the very model of a modern major general' }

      it 'skips lines with invalid duration' do
        allow(STDERR).to receive(:puts).with("Warning: skipping row. Invalid data detected '#{bad_duration}'.")
        expect(NormalizeCsv::Parser.parse(bad_duration)).to be_nil
      end

      it 'skips lines with invalid date' do
        allow(STDERR).to receive(:puts).with("Warning: skipping row. Invalid data detected '#{bad_date}'.")
        expect(NormalizeCsv::Parser.parse(bad_date)).to be_nil
      end
    end
  end
end
