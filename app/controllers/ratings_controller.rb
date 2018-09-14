class RatingsController < ApplicationController
    def index
        @ratings = Rating.all
        render :index
    end

    def show
    end

    def new
        @rating = Rating.new
        @beers = Beer.all
       
    end
    def destroy
       
        rating = Rating.find(params[:id])    
        rating.delete
        redirect_to ratings_path
    end

    def create
        Rating.create params.require(:rating).permit(:score, :beer_id)
        redirect_to ratings_path      
    end

    def edit
    end

  
end