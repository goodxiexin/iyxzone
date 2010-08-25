#
# 这个GamesController和User::GamesController虽然名字一样，但是处于不同的namespace
# 因此功能也不同，User::GamesController 主要管用户玩的游戏
#
class GamesController < ApplicationController

  caches_page :show

  def show
    @game = Game.find(params[:id])
    render :json => @game.to_json(:include => [:servers, :areas, :races, :professions])
  end

end
