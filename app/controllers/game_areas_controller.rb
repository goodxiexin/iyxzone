class GameAreasController < ApplicationController

  #caches_page :show

  def show
    @area = GameArea.find(params[:id])
    render :json => @area.to_json(:include => :servers)
  end

end
