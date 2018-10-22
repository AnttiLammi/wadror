class RatingsController < ApplicationController
  def index
    ## cacheen kirjoittamisen yhteydessä asetetaan 10 minuutin expireaika, luetaan tiedot cachestä jos ne löytyy.
    Rails.cache.write("beer top 3", Beer.top(3), expires_in: 10.minutes) if Rails.cache.read("beer top 3").nil?
    @top_beers = Rails.cache.read "beer top 3"

    Rails.cache.write("recent ratings", Rating.recent, expires_in: 10.minutes) if Rails.cache.read("recent ratings").nil?
    @ratings = Rails.cache.read "recent ratings"

    Rails.cache.write("style top 3", Style.top(3), expires_in: 10.minutes) if Rails.cache.read("style top 3").nil?
    @styles = Rails.cache.read "style top 3"

    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in: 10.minutes) if Rails.cache.read("brewery top 3").nil?
    @breweries = Rails.cache.read "brewery top 3"

    Rails.cache.write("user top 3", User.top(3), expires_in: 10.minutes) if Rails.cache.read("user top 3").nil?
    @users = Rails.cache.read "user top 3"

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
    rating.delete if current_user == rating.user
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
