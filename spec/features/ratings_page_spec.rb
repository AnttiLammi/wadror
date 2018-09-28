require 'rails_helper'

include Helpers

describe "Ratings page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when rating is given, registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "shows existing ratings and their count on the page" do
    FactoryBot.create :rating, beer: beer1, score: 15, user: user
    FactoryBot.create :rating, beer: beer1, score: 10, user: user
    FactoryBot.create :rating, beer: beer2, score: 20, user: user

    visit ratings_path

    expect(page).to have_content "Has 3 ratings"
    expect(page).to have_content "iso 3: 10"
    expect(page).to have_content "iso 3: 15"
    expect(page).to have_content "Karhu: 20"
  end
end