
Geocoder.configure(
  timeout: 5,
  cache: Rails.cache,         # reuse our Rails cache
  units: :mi,                 # or :km

  )
