class Rating < ApplicationRecord
    belongs_to :beer

    def to_s
        beername = self.beer.name
        score = self.score

        return "#{beername}: #{score}"
    end

    
end
