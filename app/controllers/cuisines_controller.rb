class CuisinesController < ApplicationController
  before_action :authenticate_restaurant!
  def index
    @cuisines = Cuisine.where(restaurant_id: current_restaurant.id)
  end
  def new
    @cuisine = Cuisine.new
  end
  def create
    @cuisine = Cuisine.new(cuisine_params)
    if @cuisine.save
      redirect_to cuisines_path
    else
      render action: :new
    end

  end
  
  private
  def cuisine_params
    params.require(:cuisine).permit(:name, :discription, :image, :price, :cook_time).merge(restaurant_id: current_restaurant.id)
  end
end
