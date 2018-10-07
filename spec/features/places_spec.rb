require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, all are shown on the page" do
    allow(BeermappingApi).to receive(:places_in).with("vantaa").and_return(
      [ Place.new( name:"Steissin pubi", id: 2 ), Place.new(name:"Sir Kippis", id:3)]
    )
    visit places_path
    fill_in('city', with: 'vantaa')
    click_button "Search"
    expect(page).to have_content "Steissin pubi" 
    expect(page).to have_content "Sir Kippis" 
  end

  it "if none are returned by the API, show correct notice" do
    allow(BeermappingApi).to receive(:places_in).with("hyvinkää").and_return([])
    visit places_path
    fill_in('city', with: 'hyvinkää')
    click_button "Search"

    expect(page).to have_content "No locations in hyvinkää"
  end
end