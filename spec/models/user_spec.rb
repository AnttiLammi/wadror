require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved without a valid password" do
    user = User.create username:"Pekka", password:"Ab1", password_confirmation:"Ab1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)

    user = User.create username:"Pekka", password:"Password", password_confirmation:"Password"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_style) {FactoryBot.create(:style, name:teststyle)}
    let(:test_beer) { Beer.create name: "testbeer", style_id: :test_style.id, brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user) 
      
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
    create_beer_with_rating({ user: user }, 10 )
    create_beer_with_rating({ user: user}, 7 )
    best = create_beer_with_rating({ user: user }, 25 )

    expect(user.favorite_beer).to eq(best)
    end    
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
    it "has method for determining the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest rating if several rated" do 
      averagestyle = FactoryBot.create(:style, name:"Weizen")
      average = FactoryBot.create(:beer, style_id:averagestyle.id)
      FactoryBot.create(:rating, score:30, beer:average, user:user)

      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user}, 7 )
      create_beer_with_rating({ user: user }, 25 )

      beststyle = FactoryBot.create(:style, name:"IPA")
      best = FactoryBot.create(:beer, style_id: beststyle.id)
      FactoryBot.create(:rating, score:40, beer: best, user:user)

      expect(user.favorite_style).to eq(best.style)
    end

  end

  describe "favorite brewery" do 
    let(:user){ FactoryBot.create(:user) }
    it "has method for determening favorite_brewery" do 
      expect(user).to respond_to(:favorite_brewery)
    end
    
    it "without ratings does not have a favorite brewery" do 
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user:user)
      
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest rating if several rated" do
      averagebrew = FactoryBot.create(:brewery, name: "AverageBrew")
      averagebeer = FactoryBot.create(:beer, brewery:averagebrew)
      FactoryBot.create(:rating, score: 30, beer:averagebeer, user:user)

      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user}, 7 )
      create_beer_with_rating({ user: user }, 25 )

      bestbrew = FactoryBot.create(:brewery, name: "BestBrew")
      bestbeer = FactoryBot.create(:beer, brewery:bestbrew)
      FactoryBot.create(:rating, score:45, beer:bestbeer, user:user)
      FactoryBot.create(:rating, score:40, beer:bestbeer, user:user)

      expect(user.favorite_brewery).to eq(bestbrew)
    end
  end
  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
    beer
  end

  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end
end