require "rails_helper"

RSpec.describe AtmService do
  it "returns nearby atm data" do
    atm_results = AtmService.nearby_atms(35, -106.6)
    expect(atm_results).to be_a(Hash)
    expect(atm_results[:results]).to be_an(Array)
    atm_data = atm_results[:results].first

    expect(atm_data).to include(:dist, :poi, :address, :position)
    expect(atm_data[:poi]).to have_key(:name)
    expect(atm_data[:address]).to have_key(:freeformAddress)
    expect(atm_data[:position]).to include(:lat, :lon)
  end
end