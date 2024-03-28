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
  
  describe '#filter_markets' do
    let!(:market1) { create(:market, state: 'California', city: 'Los Angeles', name: 'Farmers Market') }
    let!(:market2) { create(:market, state: 'California', city: 'San Francisco', name: 'Fish Market') }
    let!(:market3) { create(:market, state: 'New York', city: 'New York City', name: 'Green Market') }

    it 'filters markets by state' do
      filtered_markets = Market.filter_markets('California', nil, nil)
      expect(filtered_markets).to include(market1, market2)
      expect(filtered_markets).not_to include(market3)
    end

    it 'filters markets by city' do
      filtered_markets = Market.filter_markets(nil, 'Los Angeles', nil)
      expect(filtered_markets).to include(market1)
      expect(filtered_markets).not_to include(market2, market3)
    end

    it 'filters markets by name' do
      filtered_markets = Market.filter_markets(nil, nil, 'Market')
      expect(filtered_markets).to include(market1, market2, market3)
    end

    it 'filters markets by state, city, and name' do
      filtered_markets = Market.filter_markets('California', 'Los Angeles', 'Farmers')
      expect(filtered_markets).to include(market1)
      expect(filtered_markets).not_to include(market2, market3)
    end

    it 'returns all markets if no filters are applied' do
      filtered_markets = Market.filter_markets(nil, nil, nil)
      expect(filtered_markets).to include(market1, market2, market3)
    end
  end

end
