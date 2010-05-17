class User::Guilds::MembershipsController < UserBaseController

  layout 'app'

  Category = [:member_and_veteran_memberships, :invitations, :requests]

  def index
		@memberships = eval("@guild.#{Category[params[:type].to_i]}").prefetch([:character, {:user => :profile}])
  end

  def edit
    render :action => 'edit', :layout => false  
  end
  
  def update
    if @membership.change_role params[:status]
      render :update do |page|
        page << "facebox.close();"
        page << "$('member_status_#{@membership.id}').innerHTML = '#{@membership.to_s}'"
      end
    else
      render_js_error 
    end 
  end

  def destroy
    if @membership.evict
      render :update do |page|
        page << "$('membership_#{@membership.id}').remove();"
      end
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
