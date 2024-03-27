class Vendor < ApplicationRecord
  validates_presence_of :name,
                        

  has_many :market_vendors
  has_many :markets, through: :market_vendors
end
