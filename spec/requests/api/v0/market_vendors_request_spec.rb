require "rails_helper"

describe "MarketVendors API" do
  it "can create market/vendor association" do
    market = create(:market)
    vendor = create(:vendor)

    header = {"CONTENT_TYPE" => "application/json"}
    body = JSON.generate({market_id: market.id, vendor_id: vendor.id})
    post "/api/v0/market_vendors", headers: header, params: body

    expect(response).to be_successful
    expect(response.status).to eq(201)

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    expect(formatted_response[:message]).to eq("Successfully added vendor to market")

    get "/api/v0/markets/#{market.id}/vendors"

    formatted_response = JSON.parse(response.body, symbolize_names: true)
    vendors = formatted_response[:data]

    expect(vendor[:id]).to eq(vendor.id)
  end

  it "can delete market/vendor association" do
    market = create(:market)
    vendor = create(:vendor)
    market_vendor = MarketVendor.create(market_id: market.id, vendor_id: vendor.id)
    
    expect(MarketVendor.count).to eq(1)

    header = {"CONTENT_TYPE" => "application/json"}
    body = JSON.generate({market_id: market.id, vendor_id: vendor.id})
    delete "/api/v0/market_vendors", headers: header, params: body

    expect(response).to be_successful
    expect(response.status).to eq(204)
    expect(MarketVendor.count).to eq(0)
    expect{MarketVendor.find(market_vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "error responses" do
    it "if merchant id invalid" do
      vendor = create(:vendor)
  
      header = {"CONTENT_TYPE" => "application/json"}
      body = JSON.generate({market_id: 2, vendor_id: vendor.id})
      post "/api/v0/market_vendors", headers: header, params: body

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
  
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      error_response = formatted_response[:errors]

      expect(error_response.first[:detail]).to start_with("Couldn't find Market with 'id'=")
    end

    it "if vendor id invalid" do
      market = create(:market)
  
      header = {"CONTENT_TYPE" => "application/json"}
      body = JSON.generate({market_id: market.id, vendor_id: 2})
      post "/api/v0/market_vendors", headers: header, params: body

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
  
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      error_response = formatted_response[:errors]

      expect(error_response.first[:detail]).to start_with("Couldn't find Vendor with 'id'=")
    end

    it "if no merchant id or vendor id provided" do
      header = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      body = JSON.generate({market_id: '', vendor_id: ''})
      post "/api/v0/market_vendors", headers: header, params: body

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
  
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      error_response = formatted_response[:errors]

      expect(error_response.first[:detail]).to eq("Validation failed: Neither Market or Vendor can be blank")
    end

    it "if market_vendor already exists" do
      market = create(:market)
      vendor = create(:vendor)
  
      header = {"CONTENT_TYPE" => "application/json"}
      body = JSON.generate({market_id: market.id, vendor_id: vendor.id})
      post "/api/v0/market_vendors", headers: header, params: body
  
      expect(response).to be_successful
      expect(response.status).to eq(201)

      post "/api/v0/market_vendors", headers: header, params: body

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
  
      formatted_response = JSON.parse(response.body, symbolize_names: true)
      error_response = formatted_response[:errors]
      
      expect(error_response.first[:detail]).to eq("Validation failed: Market vendor asociation already exists")
    end

    it "if try to delete nonexistent market_vendor" do
      market = create(:market)
      vendor = create(:vendor)
  
      header = {"CONTENT_TYPE" => "application/json"}
      body = JSON.generate({market_id: market.id, vendor_id: vendor.id})
      delete "/api/v0/market_vendors", headers: header, params: body
  
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      formatted_response = JSON.parse(response.body, symbolize_names: true)
      error_response = formatted_response[:errors]
      
      expect(error_response.first[:detail]).to eq("No market vendor asociation between market_id=#{market.id} and vendor_id=#{vendor.id}")
    end
  end
end