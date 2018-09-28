class User < ApplicationRecord
  include RatingAverage
  validates :username, uniqueness: true, length: 3..30
  has_many :membership
  has_many :beer_clubs, through: :membership
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_secure_password

  validates :password, length: { minimum: 4 }, format: { with: /\A.*[0-9]+.*\z/ }
  validates :password, format: { with: /\A.*[A-Z]+.*\z/ }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ratings.group_by{ |i| i.beer.style }

    max = 0
    favoritestyle = nil
    ustyles.each do |r|
      styleratingaverage = styles[r].map(&:score).sum / (1.0 * styles[r].count)
      next if styleratingaverage < max

      max = styleratingaverage
      favoritestyle = r
    end
    favoritestyle
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings.first.beer.brewery
    breweries = ratings.group_by{ |i| i.beer.brewery }
    max = 0
    favoritebrewery = nil
    ubreweries.each do |r|
      breweryratingaverage = breweries[r].map(&:score).sum / (1.0 * breweries[r].count)
      next if breweryratingaverage < max

      max = breweryratingaverage
      favoritebrewery = r
    end
    favoritebrewery
  end

  def ubreweries
    userbreweries = ratings.map{ |r| r.beer.brewery }
    userbreweries.uniq
  end

  def ustyles
    userstyles = ratings.map{ |r| r.beer.style }
    userstyles.uniq
  end
end
