require "rails_helper"

describe "Market API" do
  it "sends a list of markets" do
    create_list(:market, 5)

    get "/api/v0/markets"

    expect(response).to be_successful

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    markets = formatted_response[:data]

    expect(markets.count).to eq(5)

    markets.each do |market|
      expect(market).to include(:id, :type, :attributes)

      expect(market[:id]).to be_a(String)
      expect(market[:type]).to be_a(String)
      expect(market[:attributes]).to be_a(Hash)
      
      expect(market[:attributes]).to include(
        :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count
      )

      expect(market[:attributes].except(:vendor_count).values).to all(be_a(String))
      expect(market[:attributes][:vendor_count]).to be_an(Integer)
    end
  end

  it "can get a market by its id" do
    market_1 = create(:market)

    get "/api/v0/markets/#{market_1.id}"

    expect(response).to be_successful

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    market = formatted_response[:data]

    expect(market).to include(:id, :type, :attributes)

    expect(market[:id]).to be_a(String)
    expect(market[:type]).to be_a(String)
    expect(market[:attributes]).to be_a(Hash)
    
    expect(market[:attributes]).to include(
      :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count
    )
    
    expect(market[:attributes].except(:vendor_count).values).to all(be_a(String))
    expect(market[:attributes][:vendor_count]).to be_an(Integer)
  end

  it "returns error message when given invalid market id" do
    get "/api/v0/markets/1"

    expect(response).to_not be_successful
    expect(response.status).to eq 404

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    error_response = formatted_response[:errors]
    expect(error_response).to be_an(Array)
    expect(error_response.first).to have_key(:detail)
    expect(error_response.first[:detail]).to start_with("Couldn't find Market with 'id'=")
  end
end