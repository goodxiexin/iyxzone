class Status::CommentsController < CommentsController

  before_filter :owner_required, :only => [:destroy]

  before_filter :friend_or_owner_required, :only => [:index, :create]

protected

  def catch_commentable
    @status = Status.find(params[:status_id])
    @user = @status.poster
    @commentable = @status
		@type = 'status'
  rescue
    not_found
  end 

	def owner_required
    @user == current_user || @comment.poster == current_user || not_found
  end	

end
