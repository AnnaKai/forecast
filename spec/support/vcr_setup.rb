# frozen_string_literal: true

# spec/support/vcr_setup.rb
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.hook_into :webmock

  config.ignore_hosts 'chromedriver.storage.googleapis.com'
  config.filter_sensitive_data('<OPENWEATHER_API_KEY>') { ENV.fetch('OPENWEATHER_API_KEY', nil) }

  config.default_cassette_options = { record: :new_episodes }
end
