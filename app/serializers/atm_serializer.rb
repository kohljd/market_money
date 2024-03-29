class AtmSerializer
  def self.format_atms(atms)
    {
      data: atms.map do |atm|
        {
          id: nil,
          type: "atm",
          attributes: {
              name: atm.name,
              address: atm.address,
              lat: atm.lat,
              lon: atm.lon,
              distance: atm.distance
          }
        }
      end
    }
  end
end