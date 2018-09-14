module RatingAverage
    extend ActiveSupport::Concern
    def average_rating
        if self.ratings.count != 0
            map = self.ratings.all.map{|rating| rating.score}
            return 1.0*map.sum/self.ratings.count
        end
    end
end