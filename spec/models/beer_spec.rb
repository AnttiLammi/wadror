require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a name, style and brewery" do
    let(:brewery) {Brewery.create name:"Brewdog", year:2007}
    let(:beer){ Beer.create name:"Punk IPA", style:"IPA", brewery_id: brewery.id}

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
  
  describe "is not saved without if missing" do
    let(:brewery) {Brewery.create name:"Brewdog", year:2007}
    it "name" do
      beer = Beer.create style:"IPA", brewery_id: brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "style" do
      beer =  Beer.create name:"Punk IPA", brewery_id: brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end