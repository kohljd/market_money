require "rails_helper"

describe "Market API" do
  it "can list atms near a market's location" do
    market_1 = create(:market)

    get "/api/v0/markets/#{market_1.id}/nearest_atms"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    atms = formatted_response[:data]

    atms.each do |atm|
      expect(atm).to include(:id, :type, :attributes)

      expect(atm[:id]).to eq(nil)
      expect(atm[:type]).to be_a(String)
      expect(atm[:attributes]).to be_a(Hash)

      expect(atm[:attributes]).to include(
        :name, :address, :lat, :lon, :distance
      )

      expect(atm[:attributes][:name]).to be_a(String)
      expect(atm[:attributes][:address]).to be_a(String)
      expect(atm[:attributes][:lat]).to be_an(Float)
      expect(atm[:attributes][:lon]).to be_an(Float)
      expect(atm[:attributes][:distance]).to be_an(Float)
    end

    atms_by_distance = atms.sort_by { |atm| atm[:attributes][:distance]}
    expect(atms).to eq(atms_by_distance)
  end
end