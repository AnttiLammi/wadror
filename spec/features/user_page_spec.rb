require 'rails_helper'

include Helpers

describe "User page" do
  before :each do
    @user = FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
      
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "ratings" do
    let!(:brew1) {FactoryBot.create :brewery, name: "Koff", year: 1897}
    let!(:beer1) {FactoryBot.create :beer, name: "iso 3", brewery: brew1}
    let!(:rate1) {FactoryBot.create :rating, score:25, beer: beer1, user: @user}   
    let!(:rate2) {FactoryBot.create :rating, score:20, beer: beer1, user: @user}
    let!(:style) {FactoryBot.create :style}
    it "shows users own ratings" do
      user2 = FactoryBot.create :user, username: 'PekanKaveri'
      FactoryBot.create :rating, score: 15, beer: beer1, user: user2

      visit user_path(@user)
      @user.ratings.each { |r|
        expect(page).to have_content r.beer.name
        expect(page).to have_content r.score
      }
    
      expect(page).not_to have_content Rating.last.score
    end

    it "can delete own ratings" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user)
      page.first(:link, 'delete').click

      expect(@user.ratings.count).to eq(1)
      expect(@user.ratings.first).to eq(rate2)
    end

    it "when exists shows favorite brewery" do
        visit user_path(@user)
        expect(page).to have_content "Favorite brewery: #{@user.favorite_brewery.name}"
    end

    it "when exists has favorite style" do
      
        visit user_path(@user)
        expect(page).to have_content "Favorite style: anonstyle"
    end
  end
end