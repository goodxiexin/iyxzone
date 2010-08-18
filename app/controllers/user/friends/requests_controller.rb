class User::Friends::RequestsController < UserBaseController

	def new
	  @recipient = User.find(params[:friend_id])
  end

  def create
    @request = Friendship.new((params[:request] || {}).merge({:user_id => current_user.id, :status => Friendship::Request}))

    if @request.save
      render :json => {:code => 1}
    else
      render :json => {:code => 0, :errors => @request.errors}
    end  
  end

	def accept
		if @request.accept
      render :json => {:code => 1}
		else
      render :json => {:code => 0}
    end		
	end

	def decline
		if @request.decline
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
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
