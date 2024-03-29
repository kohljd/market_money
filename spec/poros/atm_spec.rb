require "rails_helper"

RSpec.describe Atm do
  it "is an ATM with attributes" do
    attributes = {
      dist: 169.766658,
      poi: {
        name: "ATM"
      },
      address: {
        freeformAddress: "3902 Central Avenue Southeast, Albuquerque, NM 87108"
      },
      position: {
        lat: 35.079044,
        lon: -106.60068
      }
    }

    atm = Atm.new(attributes)

    expect(atm).to be_an(Atm)
    expect(atm.name).to eq("ATM")
    expect(atm.address).to eq("3902 Central Avenue Southeast, Albuquerque, NM 87108")
    expect(atm.lat).to eq(35.079044)
    expect(atm.lon).to eq(-106.60068)
    expect(atm.distance).to eq(169.766658)
  end
end
