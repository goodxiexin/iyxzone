class User::Guilds::MembershipsController < UserBaseController

  layout 'app'

  Category = [:member_and_veteran_memberships, :invitations, :requests]

  def index
		@memberships = eval("@guild.#{Category[params[:type].to_i]}").prefetch([:character, {:user => :profile}])
  end

  def update
    if @membership.change_role params[:status]
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end 
  end

  def destroy
    if @membership.evict
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
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
