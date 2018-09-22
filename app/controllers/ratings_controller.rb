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
    rating.delete if current_user == rating_user
    redirect_to user_path(current_user)
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def edit
  end
end