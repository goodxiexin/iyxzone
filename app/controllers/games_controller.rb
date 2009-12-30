#
# 这个GamesController和User::GamesController虽然名字一样，但是处于不同的namespace
# 因此功能也不同，User::GamesController 主要管用户玩的游戏
#
class GamesController < ApplicationController

  before_filter :setup

  # ugly ..
  # how to fix it?? 
  def game_details
    if current_user.nil? # so, in register page
      @rating = Rating::DEFAULT
    else
      @rating = @game.find_rating_by_user(current_user)
      if @rating.nil?
        @rating = Rating::DEFAULT
      else
        @rating = @rating.rating
      end
    end
    if @game.no_areas
      render :json => {:no_areas => true, :no_servers => @game.no_servers, :no_races => @game.no_races, :no_professions => @game.no_professions, :servers => @game.servers, :professions => @game.professions, :races => @game.races, :rating => @rating }
    else
      render :json => {:no_areas => false, :no_servers => @game.no_servers, :no_races => @game.no_races, :no_professions => @game.no_professions, :areas => @game.areas, :professions => @game.professions, :races => @game.races, :rating => @rating }
    end
  end

  def area_details
    render :json => @area.servers
  end

protected

  def setup
    if ["game_details"].include? params[:action]
      @game = Game.find(params[:id])
      @user = current_user
    elsif ["area_details"].include? params[:action]
      @game = Game.find(params[:id])
      @area = @game.areas.find(params[:area_id])
      @user = current_user
    end
  end


end
