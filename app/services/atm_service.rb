class AtmService
  def self.nearby_atms(latitude, longitude)
    get_url("/search/2/nearbySearch/.json?lat=35.077529&lon=-106.600449&radius=10000&categorySet=7397&view=Unified&relatedPois=off")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://api.tomtom.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.tom_tom[:api_key]
    end
  end
end
