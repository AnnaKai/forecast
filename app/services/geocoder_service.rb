class GeocoderService
  ZIP_REGEX = /\b\d{5}(-\d{4})?\b/

  def self.extract_zip(address)
    return $& if address.to_s[ZIP_REGEX]

    result = Geocoder.search(address)&.first
    return unless result

    result.postal_code || result.data['address']&.dig('postcode')
  end
end
