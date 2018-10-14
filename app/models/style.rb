class Style < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def self.top(num)
    ordered = Style.all.sort_by{ |b| -(b.average_rating || 0) }
    top = ordered.take(num)
    top
  end
end
