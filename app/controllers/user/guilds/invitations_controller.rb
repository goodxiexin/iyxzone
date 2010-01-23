class User::Guilds::InvitationsController < UserBaseController

  layout 'app'

  def new
    @friends = current_user.friends
  end

  def create_multiple
    (params[:users] || {}).each { |user_id| @guild.invitations.create(:user_id => user_id) }
    redirect_to guild_url(@guild)
  end

  def edit
    render :action => 'edit', :layout => false
  end

	def accept
		unless @invitation.accept_invitation 
	    render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

	def decline
    unless @invitation.destroy
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def search
    @friends = current_user.friends.find_all {|f| f.login.include?(params[:key])}
    render :partial => 'friends'
  end

protected

  def setup
    if ['new', 'create_multiple'].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
    elsif ['edit', 'accept', 'decline'].include? params[:action]
      @invitation = current_user.guild_invitations.find(params[:id])
      @guild = @invitation.guild
    end
  rescue
    not_found
  end

end
