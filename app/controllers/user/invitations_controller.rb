class User::InvitationsController < UserBaseController

  layout 'app'

  def index
    @invitations = []
		if params[:type].blank?
			@invitations.concat current_user.event_invitations.all(:include => [{:event => [{:poster => :profile}]}])
			@invitations.concat current_user.poll_invitations.all(:include => [{:poll => [{:poster => :profile}]}])
			@invitations.concat current_user.guild_invitations.all(:include => [{:guild => [{:president => :profile}]}])
			@invitations = @invitations.paginate :page => params[:page], :per_page => 10
		elsif params[:type].to_i == 1
			@invitations = current_user.poll_invitations.paginate :page => params[:page], :per_page => 10, :include => [{:poll => [{:poster => :profile}]}]
		elsif params[:type].to_i == 2
			@invitations = current_user.event_invitations.paginate :page => params[:page], :per_page => 10, :include => [{:event => [{:poster => :profile}]}]
		elsif params[:type].to_i == 3
			@invitations = current_user.guild_invitations.paginate :page => params[:page], :per_page => 10, :include => [{:guild => [{:president => :profile}]}]
		end	
  end

end
