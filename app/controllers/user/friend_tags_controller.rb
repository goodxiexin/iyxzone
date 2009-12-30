class User::FriendTagsController < UserBaseController

  def friend_table 
    if params[:game_id] == 'all'
      @friends = current_user.friends
    else
      game = Game.find(params[:game_id])
      @friends = current_user.friends.find_all {|f| f.games.include?(game) }
    end
    render :partial => 'friend_table', :object => @friends
  end

  def auto_complete_for_friend_tags
    @friends = current_user.friends.find_all {|f| f.pinyin.starts_with?(params[:friend][:login])}
    render :partial => 'friends' 
  end

	def destroy
		@tag.destroy
		render :nothing => true
	end

protected

	def setup
    if ['destroy'].include? params[:action]
		  @tag = FriendTag.find(params[:id])
		  @taggable = @tag.taggable
		  @user = @taggable.poster # a hack. currently, only blog and video are available here
    end
	end

end

