class Friend::FriendsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

	before_filter :not_friend_required, :only => [:new]

	before_filter :not_myself_required, :only => [:other, :common]
	
  def index
    case params[:term].to_i
    when 0
      @friends = current_user.friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 1
      @friends = current_user.friends.find_all {|f| f.games.include?(@game) }.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    when 2
      @friends = current_user.friends.find_all {|f| f.all_guilds.include?(@guild) }.paginate :page => params[:page], :per_page => 12, :order => 'created_at DESC'
    end
  end

  def new
		render :action => 'new', :layout => 'app2'
  end

	# other people's friends list
	def other
		@friends = @user.friends.paginate :page => params[:page], :per_page => 18
	end

	# common friends with ...
	def common
		@friends = @user.common_friends_with(current_user).paginate :page => params[:page], :per_page => 18
	end

  def destroy
    Friendship.transaction do
      Friendship.find(:first, :conditions => {:user_id => current_user.id, :friend_id => @friend.id}).destroy
      Friendship.find(:first, :conditions => {:user_id => @friend.id, :friend_id => current_user.id}).destroy
    end
    render :update do |page|
      page << "alert('成功');$('friend_#{params[:id]}').remove();"
    end
  end

  def search
    @friends = current_user.friends.search(params[:key])
    @friends = @friends.paginate :page => params[:page], :per_page => 12, :order => 'login ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :key => params[:key]}}
    render :partial => 'friends', :object => @friends
  end

protected

  def setup
    if ["index"].include? params[:action]
			@user = current_user
			@game = Game.find(params[:game_id]) unless params[:game_id].nil?
			@guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
		elsif ["destroy"].include? params[:action]
      @friend = current_user.friends.find(params[:id])
    elsif ["new"].include? params[:action]
			@user = User.find(params[:id])
			@profile = @user.profile
		elsif ["other", "common"].include? params[:action]
			@user = User.find(params[:id])
		end
  rescue
    not_found
  end

	def not_friend_required
		!@user.has_friend?(current_user) || not_found 
	end

	def not_myself_required
		@user != current_user || not_found
	end
	
end

