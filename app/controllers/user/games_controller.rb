class User::GamesController < ApplicationController

  layout 'app2'

  before_filter :login_required, :setup

  def index
    @games = @user.games.paginate :page => params[:page], :per_page => 10
    render :action => "index", :layout => "app"      
  end

  def friends
    @games = current_user.friends.map(&:games).flatten.uniq.paginate :page => params[:page], :per_page => 10
    render :action => "friends", :layout => "app"
  end

  #
  # sex 和 hot 的区别是
  # sex是按照过去一周这个游戏有多少游戏角色而定的
  # hot是按照这一周里有多少人关注这个游戏而定的
  # 
  def sex
    @games = Game.sex.paginate :page => params[:page], :per_page => 10
    render :action => "sex", :layout => "app"
  end

  def show
    @blogs = @game.blogs.find(:all, :limit => 3)
    @albums = @game.albums.find(:all, :limit => 3)
    @tagging = @game.taggings.find_by_poster_id(current_user.id)
    @taggable = @tagging.nil? || (@tagging.created_at < 1.week.ago) || false
    @comments = @game.comments.paginate :page => 1, :per_page => 10
  end

  def hot
    @games = Game.hot.paginate :page => params[:page], :per_page => 1
    @remote = {:update => 'hot_games_list', :url => {:action => 'hot'}} 
    render :action => 'hot', :layout => false
  end

  def beta
    @games = Game.beta.paginate :page => params[:page], :per_page => 1
    @remote = {:update => 'beta_games_list', :url => {:action => 'beta'}}
    render :action => 'beta', :layout => false
  end

protected

  def setup
    if ["index", "sex"].include? params[:action]
      @user = User.find(params[:id]) 
    elsif ["show"].include? params[:action]
      @game = Game.find(params[:id])
    elsif ["hot", "beta"].include? params[:action]
      @user = current_user
    elsif ["game_details"].include? params[:action]
      @game = Game.find(params[:id])
      @user = current_user
    elsif ["area_details"].include? params[:action]
      @game = Game.find(params[:id])
      @area = @game.areas.find(params[:area_id])
      @user = current_user
    end
  end

end
