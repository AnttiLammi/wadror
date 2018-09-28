require 'rails_helper'

include Helpers

describe "Beer page" do
  let!(:brewery) {FactoryBot.create :brewery, name:"Hartwall"}
  let!(:user) {FactoryBot.create :user}
  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "creates new beer if name valid" do
    visit new_beer_path
    fill_in('beer[name]', with:'Karjala')
    expect{click_button "Create Beer"}.to change{Beer.count}
  end

  it "does not create beer if invalid name and displays error" do
    visit new_beer_path
    expect{click_button "Create Beer"}.not_to change{Beer.count}
    expect(page).to have_content "Name can't be blank"
  end
end