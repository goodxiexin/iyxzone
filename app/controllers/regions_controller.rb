class RegionsController < ApplicationController

  caches_page :show

  before_filter :login_required

  def show
    @region = Region.find(params[:id])
    render :json => @region.to_json(:include => [:cities])
  end

end
