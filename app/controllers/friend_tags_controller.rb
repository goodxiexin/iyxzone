class FriendTagsController < ApplicationController

	before_filter :login_required

	before_filter :setup, :only => [:destroy]

	before_filter :owner_required, :only => [:destroy]

  def games_list
    render :partial => 'games_list', :object => current_user.games
  end

  def friends_list
    if params[:game_id] == 'all'
      @friends = current_user.friends
    else
      game = Game.find(params[:game_id])
      @friends = current_user.friends.find_all {|f| f.games.include?(game) }
    end
    render :partial => 'friends_list', :object => @friends
  end

  def auto_complete_for_friend_login
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:friend][:login]) }
    render :partial => 'friends' 
  end

	def destroy
		@tag.destroy
		render :nothing => true
	end

protected

	def setup
		@tag = FriendTag.find(params[:id])
		@taggable = @tag.taggable
		@user = @taggable.poster
	rescue
		not_found
	end

end

