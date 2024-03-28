class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def vendor_count
    vendors.count
  end

  def self.filter_markets(state, city, name)
    markets = Market.all
    markets = markets.where("state ILIKE ?", "%#{state}%") if state.present?
    markets = markets.where("city ILIKE ?", "%#{city}%") if city.present?
    markets = markets.where("name ILIKE ?", "%#{name}%") if name.present?
    markets
  end
end