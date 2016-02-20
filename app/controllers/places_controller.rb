class PlacesController < ApplicationController
  def index
  end
  
  def show
    @places = BeermappingApi.places_in(session[:searched_city])
    @place = @places.select{|key, hash| key.id == params[:id] }.first
  end
  
  def search
    if params[:city] == ""
      redirect_to places_path, notice: "Please include at least one character in your query"
      return
    end
    
    @places = BeermappingApi.places_in(params[:city])
    
    session[:searched_city] = params[:city]
    
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
    
  end
end