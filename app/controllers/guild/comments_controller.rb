class Guild::CommentsController < CommentsController

  layout 'app'

  before_filter :catch_membership, :only => [:index, :create]

  before_filter :owner_required, :only => [:destroy]

  before_filter :member_required, :only => [:create]

protected

  def catch_commentable
    @guild = Guild.find(params[:guild_id])
    @user = @guild.president
    @commentable = @guild
  rescue
    not_found
  end

  def catch_membership
    @membership = @guild.memberships.find_by_user_id(current_user.id)
  end

  def member_required
    @membership || member_denied
  end

  def member_denied
    flash[:notice] = "你必须加入到此活动才能进行那些操作"
    redirect_to guild_url(@guild)
  end


end
