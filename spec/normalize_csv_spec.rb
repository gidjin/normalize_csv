require 'normalize_csv/row'

RSpec.describe NormalizeCsv do
  it 'has a version number' do
    expect(NormalizeCsv::VERSION).not_to be nil
  end

  describe '#process' do
    let(:csv_header) { "Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes\n" }
    let(:csv_line) { '4/1/11 11:00:00 AM,"123 4th ☃  St, Anywhere, AA",94121,Monkey 🐵 Alberto,1:2:3.123,1:2:3.123,zzsasdfa⚑,I am the very model of a modern major general ⚑' }
    let(:csv_line2) { '5/1/11 11:00:00 AM,"124 4th ☃  St, Anywhere, AA",94121,Monkey 🐵 Alberto,1:2:3.123,1:2:3.123,zzsasdfa⚑,I am the very model of a modern major general ⚑' }
    let(:expected_row) do
      NormalizeCsv::Row.new(
        timestamp: Time.new(2011,4,1,11,0,0, "-07:00").in_time_zone('US/Pacific'),
        address: '123 4th ☃  St, Anywhere, AA',
        zip: 94121,
        full_name: 'Monkey 🐵 Alberto',
        foo_duration: 3723.123,
        bar_duration: 3723.123,
        notes: 'I am the very model of a modern major general ⚑'
      )
    end
    let(:expected_row2) do
      NormalizeCsv::Row.new(
        timestamp: Time.new(2011,5,1,11,0,0, "-07:00").in_time_zone('US/Pacific'),
        address: '124 4th ☃  St, Anywhere, AA',
        zip: 94121,
        full_name: 'Monkey 🐵 Alberto',
        foo_duration: 3723.123,
        bar_duration: 3723.123,
        notes: 'I am the very model of a modern major general ⚑'
      )
    end

    before do
      allow(STDIN).to receive(:each_line)
        .and_yield(csv_header).and_yield(csv_line).and_yield(csv_line2)
      allow(NormalizeCsv::Parser).to receive(:parse).with(csv_line).and_return(expected_row)
      allow(NormalizeCsv::Parser).to receive(:parse).with(csv_line2).and_return(expected_row2)
      allow(NormalizeCsv::Output).to receive(:csv_header).and_return('first row')
      allow(NormalizeCsv::Output).to receive(:csv_row).with(expected_row).and_return('second row')
      allow(NormalizeCsv::Output).to receive(:csv_row).with(expected_row2).and_return('third row')
      allow(STDOUT).to receive(:puts)
    end

    it 'reads line from STDIN and calls parse for each except header' do
      expect(NormalizeCsv::Parser).to receive(:parse).with(csv_line)
      expect(NormalizeCsv::Parser).to receive(:parse).with(csv_line2)
      NormalizeCsv.process
    end

    it 'passes row object to output' do
      expect(NormalizeCsv::Output).to receive(:csv_row).with(expected_row)
      expect(NormalizeCsv::Output).to receive(:csv_row).with(expected_row2)
      NormalizeCsv.process
    end

    it 'calls for the header' do
      expect(NormalizeCsv::Output).to receive(:csv_header)
      NormalizeCsv.process
    end

    it 'prints all to STDOUT in order' do
      expect(STDOUT).to receive(:puts).with('first row').ordered
      expect(STDOUT).to receive(:puts).with('second row').ordered
      expect(STDOUT).to receive(:puts).with('third row').ordered
      NormalizeCsv.process
    end

    it 'handles nil parsed row' do
      allow(NormalizeCsv::Parser).to receive(:parse).and_return(nil)
      expect{NormalizeCsv.process}.not_to raise_error
    end
  end
end
