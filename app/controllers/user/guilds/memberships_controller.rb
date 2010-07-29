class User::Guilds::MembershipsController < UserBaseController

  layout 'app'

  Category = [:member_and_veteran_memberships, :invitations, :requests]

  def index
		@memberships = eval("@guild.#{Category[params[:type].to_i]}").prefetch([:character, {:user => :profile}])
  end

  def update
    if @membership.change_role params[:status]
      render_js_code "Iyxzone.Facebox.close()();$('member_status_#{@membership.id}').innerHTML = '#{@membership.to_s}'"
    else
      render_js_error 
    end 
  end

  def destroy
    if @membership.evict
      render_js_code "$('membership_#{@membership.id}').remove();"
    else
      render_js_error
    end
  end

protected

  def setup
    if ['index'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_verified @guild
      @user = @guild.president
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_verified @guild
      require_owner @guild.president
      @membership = @guild.memberships.find(params[:id])
    end
  end

end
