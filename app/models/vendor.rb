class Vendor < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :contact_name,
                        :contact_phone
  
  validate :credit_accepted_boolean

  has_many :market_vendors
  has_many :markets, through: :market_vendors

  def credit_accepted_boolean
    credit_accepted.in? [true, false]
  end
end
