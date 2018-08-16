RSpec.describe NormalizeCsv::Parser do
  describe '#parse' do
    describe 'with utf-8' do
      describe 'that is valid' do
        let(:csv_line) { '4/1/11 11:00:00 AM,"123 4th ☃  St, Anywhere, AA",94121,Monkey 🐵 Alberto,1:2:3.123,1:2:3.123,zzsasdfa⚑,I am the very model of a modern major general ⚑' }
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
        let(:result) { NormalizeCsv::Parser.parse(csv_line) }

        it 'returns row object' do
          expect(result).to be_a_kind_of(NormalizeCsv::Row)
        end

        it 'returns correct address' do
          expect(result.address).to eq(expected_row.address)
        end

        it 'returns correct full_name' do
          expect(result.full_name).to eq(expected_row.full_name)
        end

        it 'returns correct notes' do
          expect(result.notes).to eq(expected_row.notes)
        end
      end
      describe 'that is NOT valid' do
        # "2/29/16 12:11:11 PM,111 Ste. #123123123,1101,R\xC3\x83\xC2\xA9sum\xC3\x83\xC2\xA9 Ron,31:23:32.123,1:32:33.123,zzsasdfa,\xC3\xB0\x99!"
        let(:csv_line) do
          [50, 47, 50, 57, 47, 49, 54, 32, 49, 50, 58, 49, 49, 58, 49, 49, 32, 80, 77, 44, 49, 49, 49, 32, 83, 116, 101, 46, 32, 35, 49, 50, 51, 49, 50, 51, 49, 50, 51, 44, 49, 49, 48, 49, 44, 82, 195, 131, 194, 169, 115, 117, 109,195, 131, 194, 169, 32, 82, 111, 110, 44, 51, 49, 58, 50, 51, 58, 51, 50, 46, 49, 50, 51, 44, 49, 58, 51, 50, 58, 51, 51, 46, 49, 50, 51, 44, 122, 122, 115, 97, 115, 100, 102, 97, 44, 195, 176, 153, 33].pack('c*')
        end
        let(:expected_row) do
          NormalizeCsv::Row.new(
            timestamp: Time.new(2016,2,29,12,11,11, "-08:00").in_time_zone('US/Pacific'),
            address: '111 Ste. #123123123',
            zip: 1101,
            full_name: 'R����sum���� Ron',
            foo_duration: 113012.123,
            bar_duration: 5553.123,
            notes: '���!'
          )
        end
        let(:result) { NormalizeCsv::Parser.parse(csv_line) }

        it 'returns scrubbed address' do
          expect(result.address).to eq(expected_row.address)
        end

        it 'returns scrubbed zip' do
          expect(result.zip).to eq(expected_row.zip)
        end

        it 'returns scrubbed full_name' do
          expect(result.full_name).to eq(expected_row.full_name)
        end

        it 'returns scrubbed notes' do
          expect(result.notes).to eq(expected_row.notes)
        end
      end
    end
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

      it 'returns correct timestamp' do
        expect(result.timestamp).to eq(expected_row.timestamp)
      end

      it 'returns correct address' do
        expect(result.address).to eq(expected_row.address)
      end

      it 'returns correct zip' do
        expect(result.zip).to eq(expected_row.zip)
      end

      it 'returns correct full_name' do
        expect(result.full_name).to eq(expected_row.full_name)
      end

      it 'returns correct foo_duration' do
        expect(result.foo_duration).to eq(expected_row.foo_duration)
      end

      it 'returns correct bar_duration' do
        expect(result.bar_duration).to eq(expected_row.bar_duration)
      end

      it 'returns correct notes' do
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
