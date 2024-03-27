require "rails_helper"

RSpec.describe Vendor, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :contact_name }
    it { should validate_presence_of :contact_phone }

    it 'validates credit_accepted to be boolean' do
      vendor_1 = create(:vendor, credit_accepted: true)
      vendor_2 = create(:vendor, credit_accepted: false)

      expect(vendor_1).to be_valid
      expect(vendor_2).to be_valid
    end  
  end
end

