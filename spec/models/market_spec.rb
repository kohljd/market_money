require "rails_helper"

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "instance methods" do
    describe ".vendor_count" do
      it "counts a market's vendors" do
        market_1 = create(:market)
        vendor_1 = create(:vendor)
        vendor_2 = create(:vendor)
        market_vendors = MarketVendor.create!(market: market_1, vendor: vendor_1)
        market_vendors = MarketVendor.create!(market: market_1, vendor: vendor_2)

        expect(market_1.vendor_count).to eq(2)

        market_2 = create(:market)
        expect(market_2.vendor_count).to eq(0)
      end
    end
  end
end
