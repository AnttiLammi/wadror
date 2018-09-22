module RatingAverage
  extend ActiveSupport::Concern
  def average_rating
    return unless ratings.count != 0

    map = ratings.all.map(&:score)
    1.0 * map.sum / ratings.count
  end
end
