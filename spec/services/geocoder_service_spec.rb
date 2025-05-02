# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GeocoderService do
  describe '.extract_zip' do
    context 'when address contains a 5-digit zip code' do
      it 'extracts the zip code' do
        address = '123 Main St, Anytown, CA 12345'
        expect(described_class.extract_zip(address)).to eq('12345')
      end
    end

    context 'when address contains a 9-digit zip code' do
      it 'extracts the full zip code' do
        address = '123 Main St, Anytown, CA 12345-6789'
        expect(described_class.extract_zip(address)).to eq('12345-6789')
      end
    end

    context 'when address does not contain a zip code' do
      it 'returns nil and attempts geocoding' do
        address = '123 Main St, Anytown, CA'
        geocoder_result = Object.new
        def geocoder_result.postal_code
          '54321'
        end

        def geocoder_result.data
          {}
        end

        allow(Geocoder).to receive(:search).with(address).and_return([geocoder_result])
        expect(described_class.extract_zip(address)).to eq('54321')
      end
    end

    context 'when geocoder returns result with postal_code' do
      it 'returns the postal code' do
        address = '123 Main St, Anytown, CA'
        geocoder_result = Object.new
        def geocoder_result.postal_code
          '54321'
        end

        def geocoder_result.data
          {}
        end

        allow(Geocoder).to receive(:search).with(address).and_return([geocoder_result])
        expect(described_class.extract_zip(address)).to eq('54321')
      end
    end

    context 'when geocoder returns result with postcode in data' do
      it 'returns the postcode from data' do
        address = '123 Main St, Anytown, CA'

        geocoder_result = Object.new
        def geocoder_result.postal_code
          nil
        end

        def geocoder_result.data
          { 'address' => { 'postcode' => '98765' } }
        end

        allow(Geocoder).to receive(:search).with(address).and_return([geocoder_result])

        expect(described_class.extract_zip(address)).to eq('98765')
      end
    end

    context 'when geocoder returns no results' do
      it 'returns nil' do
        address = '123 Main St, Anytown, CA'
        allow(Geocoder).to receive(:search).with(address).and_return(nil)

        expect(described_class.extract_zip(address)).to be_nil
      end
    end

    context 'when nil address is provided' do
      it 'returns nil' do
        expect(described_class.extract_zip(nil)).to be_nil
      end
    end
  end
end
