require 'rails_helper'

describe "Vendors API" do
  it "can get one vendor by its id happy path" do
    vendor_1 = create(:vendor)
    id = vendor_1.id
    # binding.pry
      
    get "/api/v0/vendors/#{id}"
      
    vendor = JSON.parse(response.body, symbolize_names: true)
        
    expect(response).to be_successful

    expect(vendor).to have_key(:data)
    expect(vendor[:data]).to have_key(:type) 

    expect(vendor[:data]).to have_key(:id)
    expect(vendor[:data][:id]).to eq("#{id}")
      
    expect(vendor[:data][:attributes]).to have_key(:name)
    expect(vendor[:data][:attributes][:name]).to be_a(String)
      
    expect(vendor[:data][:attributes]).to have_key(:description)
    expect(vendor[:data][:attributes][:description]).to be_a(String)
      
    expect(vendor[:data][:attributes]).to have_key(:contact_name)
    expect(vendor[:data][:attributes][:contact_name]).to be_a(String)
      
    expect(vendor[:data][:attributes]).to have_key(:contact_phone)
    expect(vendor[:data][:attributes][:contact_phone]).to be_a(String)
      
    expect(vendor[:data][:attributes]).to have_key(:credit_accepted)
    expect([true, false]).to include(vendor[:data][:attributes][:credit_accepted])
  end


  it "returns error if vendor id is invalid" do
    id = create(:vendor).id
  
    get "/api/v0/vendors/#{id+1}"
  
    vendor = JSON.parse(response.body, symbolize_names: true)
  
    expect(response).to_not be_successful

    expect(vendor).to be_a(Hash)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to be_an(Array)
    expect(vendor[:errors].first).to be_a(Hash)
    expect(vendor[:errors].first).to have_key(:detail)
    expect(vendor[:errors].first[:detail]).to include("Vendor with 'id'=")
  end

  it "can create a new vendor" do
    vendor_params = ({
                    name: 'vendor1',
                    description: 'vendordes',
                    contact_name: 'test',
                    contact_phone: '45349857',
                    credit_accepted: false
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
   
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
    created_vendor = Vendor.last
    
    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created_vendor.name).to eq(vendor_params[:name])
    expect(created_vendor.description).to eq(vendor_params[:description])
    expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
    expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
    expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
  end

  it "returns error if given invalid params to create a vendor" do
    vendor_params = ({
                    name: '',
                    description: '',
                    contact_name: '',
                    contact_phone: '',
                    credit_accepted: ''
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
  
    vendor = JSON.parse(response.body, symbolize_names: true)
    # binding.pry
  
    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    expect(vendor).to be_a(Hash)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to be_an(Array)
    expect(vendor[:errors].first).to be_a(Hash)
    expect(vendor[:errors].first).to have_key(:detail)
    expect(vendor[:errors].first[:detail]).to eq("Validation failed: Name can't be blank, Description can't be blank, Contact name can't be blank, Contact phone can't be blank")
  end
end
