class User::Friends::RequestsController < UserBaseController

	def new
	  @recipient = User.find(params[:friend_id])
    @friendship = current_user.all_friendships.find_by_friend_id(@recipient.id)
    
    if @recipient == current_user
      render :action => "not_myself"
    elsif @friendship.blank?
      render :action => 'new'
    elsif @friendship.is_request?
      render :action => "already_sent"
    elsif @friendship.is_friend?
      render :action => "already_friend"
    end
  end

  def create
    @request = Friendship.new((params[:request] || {}).merge({:user_id => current_user.id, :status => Friendship::Request}))

    if @request.save
      render_js_tip '成功，请耐心等待回复'
    else
      render_js_error
    end  
  end

  # TODO: 怎么返回错误
  def create_multiple
    params[:ids].each do |id|
      Friendship.create(:status => 0, :friend_id => id, :user_id => current_user.id)
    end
    render :nothing => true
  end

	def accept
		if @request.accept
      render_js_code "$('friend_request_option_#{@request.id}').innerHTML = '<strong class=\"nowrap\"><span class=\"icon-success\"></span>添加好友成功！</strong>';setTimeout(\"new Effect.Fade('friend_request_#{@request.id}')\", 2000);"
		else
      render_js_error
    end		
	end

	def decline
		if @request.decline
		  render_js_code "$('friend_request_option_#{@request.id}').innerHTML = '<strong class=\"nowrap\"><span class=\"icon-success\"></span>拒绝请求成功！</strong>';setTimeout(\"new Effect.Fade('friend_request_#{@request.id}')\", 2000);"
    else
      render_js_error
    end 
	end

protected

	def setup
    if ["accept", "decline"].include? params[:action]
			@request = Friendship.find(params[:id])
		  require_owner @request.friend
    end
	end

end
