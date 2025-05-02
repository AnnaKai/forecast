# Forecast App

Small Rails 8 demo for Apple take‑home.
Accepts a free‑form **address or ZIP**, returns current temperature (high/low optional) and caches each ZIP for 30 minutes.

| Layer | Gem / Tool | Reason |
|-------|------------|--------|
| Framework | **Rails 8**, **Ruby 3.4** | Zeitwerk‑only autoload. |
| HTTP | **Faraday 2** | Connection pooling |
| Geocoding | **geocoder** (Nominatim) | Free, key‑less; only used when input isn’t already a ZIP. |
| Weather | **OpenWeather** “Current Weather” API | Free tier (60 req/min, 1 k/day) via `zip=` param. |
| Caching | `Rails.cache` | Keyed by ZIP; switch to Redis in prod. |
| Lint / Test | RuboCop, RuboCop‑Rails, RuboCop‑RSpec, RSpec | CI‑ready (`bin/rspec`, `bin/rubocop`). |

## Setup

```
git clone https://github.com/AnnaKai/forecast.git
cd forecast
bundle install
# secrets
echo "OPENWEATHER_API_KEY=xxxxxxxxxxxxx" > .env
bin/rails db:create
bin/rails s
```
