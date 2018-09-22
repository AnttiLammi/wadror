class User < ApplicationRecord
  include RatingAverage
  validates :username, uniqueness: true, length: 3..30
  has_many :membership
  has_many :beer_clubs, through: :membership
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_secure_password

  validates :password, length: {minimum: 4}, format: { with: /\A.*[0-9]+.*\z/ }, format: {with: /\A.*[A-Z]+.*\z/}
end
