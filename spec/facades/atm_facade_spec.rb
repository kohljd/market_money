require "rails_helper"

RSpec.describe AtmFacade do
  it "returns nearby atms as Atm objects" do
    atms = AtmFacade.nearby_atms(35, -106.6)
    atm = atms.first

    expect(atms).to be_an(Array)
    expect(atms).to all(be_an(Atm))
  end
end