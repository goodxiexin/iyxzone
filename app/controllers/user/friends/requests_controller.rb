class User::Friends::RequestsController < UserBaseController

	def new
	  @recipient = User.find(params[:friend_id])
  end

  def create
    @request = Friendship.new((params[:request] || {}).merge({:user_id => current_user.id, :status => 0}))
    if @request.save
      render :update do |page|
        page << "tip('成功，请耐心等待回复');"
      end
    else
      render :update do |page|
        page << "error('#{@request.errors.on(:friend_id)}');"
      end
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
			render :update do |page|
				page << "$('friend_request_option_#{@request.id}').innerHTML = '已接受';"
			end
		else
      render :update do |page|
        page << "error('发生错误')"
      end
    end		
	end

	def decline
		if @request.destroy
		  render :update do |page|
			  page << "$('friend_request_option_#{@request.id}').innerHTML = '已拒绝';"
		  end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
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
