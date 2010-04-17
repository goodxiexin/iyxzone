class CitiesController < ApplicationController

  caches_page :show

  before_filter :login_required

  def show
    @city = City.find(params[:id])
    render :json => @city.to_json(:include => [:districts])
  end

end
