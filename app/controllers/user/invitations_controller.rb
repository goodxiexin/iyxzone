class User::InvitationsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  def index
    @invitations = []
		if params[:type].blank?
			@invitations.concat current_user.event_invitations.prefetch([{:event => [{:poster => :profile}]}])
			@invitations.concat current_user.poll_invitations.prefetch([{:poll => [{:poster => :profile}]}])
			@invitations.concat current_user.guild_invitations.prefetch([{:guild => [{:president => :profile}]}])
			@invitations = @invitations.sort{|a,b| a.created_at <=> b.created_at}.paginate :page => params[:page], :per_page => PER_PAGE
		elsif params[:type].to_i == 1
			@invitations = current_user.poll_invitations.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:poll => [{:poster => :profile}]}]
		elsif params[:type].to_i == 2
			@invitations = current_user.event_invitations.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:event => [{:poster => :profile}]}]
		elsif params[:type].to_i == 3
			@invitations = current_user.guild_invitations.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:guild => [{:president => :profile}]}]
		end	
  end

end
