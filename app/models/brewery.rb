class Brewery < ApplicationRecord
  include RatingAverage
  validates :name, presence: true
  validates :year, numericality: { greather_than_or_equal_to: 1040, less_than_or_equal_to: ->(_brewery) { Date.current.year }, only_integer: true }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def self.top(num)
    ordered = Brewery.all.sort_by{ |b| -(b.average_rating || 0) }
    top = ordered.take(num)
    top
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed year to #{year}"
  end
end
