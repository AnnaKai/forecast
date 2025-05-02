# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastFetcherService do
  let(:zip) { '12345' }
  let(:forecast_data) do
    { temp: 70.5, temp_min: 68.2, temp_max: 72.8 }
  end

  describe '.fetch' do
    context 'when cache miss' do
      before do
        allow(Rails.cache).to receive(:fetch)
          .with(zip, expires_in: 30.minutes)
          .and_yield
        allow(described_class).to receive(:fetch_from_api)
          .with(zip).and_return(forecast_data)
      end

      it 'returns data and cached flag = false' do
        result, cached = described_class.fetch(zip)
        expect(result).to eq(forecast_data)
        expect(cached).to be false
      end
    end

    context 'when cache hit' do
      before do
        allow(Rails.cache).to receive(:fetch)
          .with(zip, expires_in: 30.minutes)
          .and_return(forecast_data)
      end

      it 'returns data and cached flag = true' do
        result, cached = described_class.fetch(zip)
        expect(result).to eq(forecast_data)
        expect(cached).to be true
      end
    end
  end

  describe '.fetch_from_api' do
    it 'parses live data (cassette auto‑recorded)' do
      VCR.use_cassette('openweather/success') do
        result = described_class.fetch_from_api('32004')
        expect(result).to include(:temp, :temp_min, :temp_max)
        expect(result[:temp]).to be_a(Numeric)
      end
    end

    it 'raises ForecastFetcherService::Error' do
      VCR.use_cassette('openweather/error_invalid_zip') do
        expect do
          described_class.fetch_from_api('INVALID')
        end.to raise_error(ForecastFetcherService::Error, /Weather API error: (4|5)\d{2}/)
      end
    end
  end
end
