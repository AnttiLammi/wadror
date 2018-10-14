class Beer < ApplicationRecord
  include RatingAverage
  validates :name, presence: true
  belongs_to :style
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def self.top(num)
    ordered = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    top = ordered.take(num)
    top
  end

  def to_s
    "#{brewery.name}: #{name}"
  end
end
