require 'rails_helper'

describe "Vendors API" do
    it "can get one vendor by its id happy path" do
        id = create(:vendor).id
      
        get "/api/v0/vendors/#{id}"
      
        vendor = JSON.parse(response.body, symbolize_names: true)
      
        expect(response).to be_successful
      
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to eq(id)
      
        expect(vendor).to have_key(:name)
        expect(vendor[:name]).to be_a(String)
      
        expect(vendor).to have_key(:description)
        expect(vendor[:description]).to be_a(String)
      
        expect(vendor).to have_key(:contact_name)
        expect(vendor[:contact_name]).to be_a(String)
      
        expect(vendor).to have_key(:contact_phone)
        expect(vendor[:contact_phone]).to be_a(String)
      
        expect(vendor).to have_key(:credit_accepted)
        expect([true, false]).to include(vendor[:credit_accepted])
      end

      it "can get one vendor by its id sad path" do
        id = create(:vendor).id
      
        get "/api/v0/vendors/#{id+1}"
      
        vendor = JSON.parse(response.body, symbolize_names: true)
      
        expect(response).to_not be_successful

        expect(vendor).to be_a(Hash)
        expect(vendor).to have_key(:errors)
        expect(vendor[:errors]).to be_an(Array)
        expect(vendor[:errors].first).to be_a(Hash)
        expect(vendor[:errors].first).to have_key(:detail)
        expect(vendor[:errors].first[:detail]).to include("Vendor with id=")

        
        
      end

end