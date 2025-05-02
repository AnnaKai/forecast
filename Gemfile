source 'https://rubygems.org'

gem 'rails', '~> 8.0.2'
gem 'propshaft'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'geocoder', '~> 1.8'
gem 'faraday'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rubocop',           '~> 1.63', require: false
  gem 'rubocop-rails',     '~> 2.22', require: false
  gem 'rubocop-rspec',     '~> 2.27', require: false
  gem 'dotenv-rails'
end

group :test do
  gem 'rspec-rails'
  gem 'vcr',      '~> 6.2'
  gem 'webmock',  '~> 3.23'
end
