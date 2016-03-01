class RatingsController < ApplicationController

  def index
    # Muuttujille annetaan arvo välimuistista, ja jos ei löydy, käytetään
    # lambdaa ajankohtaisen tiedon löytämiseen
    @ratings = use_cache 'all_ratings', lambda { Rating.all }
    @recent_ratings = use_cache 'recent_ratings', lambda { Rating.recent }
    @top_breweries = use_cache 'top_breweries', lambda { Brewery.top 3 }
    @top_beers = use_cache 'top_beers', lambda { Beer.top 3 }
    @top_styles = use_cache 'top_styles', lambda { Style.top 3 }
    @top_raters = use_cache 'top_raters', lambda { User.top 3 }
  end
  
  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  
  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    
    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end
  
  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end
  
  def use_cache(name, data_lambda)
    Rails.cache.fetch(name, expires_in: 2.minutes) do
      data_lambda.call
    end
  end
  
end