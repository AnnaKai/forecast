class ForecastFetcherService
  CONN = Faraday.new(url: "https://api.openweathermap.org") do |f|
    f.response :json                           # auto‑parse JSON
    f.adapter  Faraday.default_adapter
  end

  class Error < StandardError; end

  def self.fetch(zip)
    cached = false
    forecast = Rails.cache.fetch(zip, expires_in: 30.minutes) do
      cached = true
      fetch_from_api(zip)
    end
    [forecast, !cached]
  end

  def self.fetch_from_api(zip)
    resp = CONN.get(
      "/data/2.5/weather",
      zip:   "#{zip},us",
      units: "imperial",
      appid: ENV["OPENWEATHER_API_KEY"]
    )

    raise Error, "Weather API error: #{resp.status}" unless resp.success?

    main = resp.body["main"]
    {
      temp:     main["temp"],
      temp_min: main["temp_min"],
      temp_max: main["temp_max"]
    }
  end
end
