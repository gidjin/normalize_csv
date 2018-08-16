# frozen_string_literal: true

RSpec.describe NormalizeCsv::Row do
  let(:timestamp) { Time.now }
  let(:address) { '221b Baker St.' }
  let(:zip) { 90210 }
  let(:full_name) { 'Sherlock Holmes' }
  let(:foo_duration) { 21 }
  let(:bar_duration) { 21 }
  let(:notes) { 'Random notes provided by user' }
  let(:row) do
    NormalizeCsv::Row.new(
      timestamp: timestamp,
      address: address,
      zip: zip,
      full_name: full_name,
      foo_duration: foo_duration,
      bar_duration: bar_duration,
      notes: notes
    )
  end

  describe '#initialize' do
    it 'accepts data as hash' do
      expect(row).to_not be_nil
    end
  end

  describe 'accessors' do
    it 'returns timestamp data' do
      expect(row.timestamp).to eq(timestamp)
    end

    it 'returns address data' do
      expect(row.address).to eq(address)
    end

    it 'returns zip data' do
      expect(row.zip).to eq(zip)
    end

    it 'returns full_name data' do
      expect(row.full_name).to eq(full_name)
    end

    it 'returns foo_duration data' do
      expect(row.foo_duration).to eq(foo_duration)
    end

    it 'returns bar_duration data' do
      expect(row.bar_duration).to eq(bar_duration)
    end

    it 'returns notes data' do
      expect(row.notes).to eq(notes)
    end
  end
end
