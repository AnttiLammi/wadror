class BeerClub < ApplicationRecord
    has_many :membership
    has_many :users, through: :membership
   
end
