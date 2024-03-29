class Atm
  attr_reader :name,
              :address,
              :lat,
              :lon,
              :distance

  def initialize(attributes)
    @name = attributes[:poi][:name]
    @address = attributes[:address][:freeformAddress]
    @lat = attributes[:position][:lat]
    @lon = attributes[:position][:lon]
    @distance = attributes[:dist]
  end
end