require "rails_helper"

describe "ATM API" do
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

  it "returns error if invalid market id for finding atms" do
    get "/api/v0/markets/1/nearest_atms"

    expect(response).to_not be_successful
    expect(response.status).to eq 404

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    error_response = formatted_response[:errors]
    expect(error_response).to be_an(Array)
    expect(error_response.first).to have_key(:detail)
    expect(error_response.first[:detail]).to start_with("Couldn't find Market with 'id'=")
  end
end
