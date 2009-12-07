class Game::GamesController < ApplicationController

	layout 'app2'

  before_filter :login_required, :except => [:game_details, :area_details]

  before_filter :setup

  def index
    @games = @user.games.paginate :page => params[:page], :per_page => 10
    render :action => "index", :layout => "app"      
  end

  def friend
    @games = current_user.friends.map(&:games).flatten.uniq.paginate :page => params[:page], :per_page => 10
    render :action => "friend", :layout => "app"
  end

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
    if ["index", "sex"].include? params[:action]
      @user = User.find(params[:id]) 
  	elsif["show", "game_details"].include? params[:action]
      @game = Game.find(params[:id])
    elsif ["game_details", "area_details"].include? params[:action]
			@game = Game.find(params[:id])
			@area = GameArea.find(params[:area_id])
		end
  rescue
    not_found
  end

end
