class AtmFacade
  def self.nearby_atms(latitude, longitude)
    json = AtmService.nearby_atms(latitude, longitude)
    json[:results].map do |atm_result|
      Atm.new(atm_result)
    end
  end
end