class User::Guilds::MembershipsController < UserBaseController

  layout 'app'

  def index
		if params[:type].to_i == 0
			@memberships = @guild.memberships.find(:all, :conditions => {:status => [Membership::Veteran, Membership::Member]})
    elsif params[:type].to_i == 1
      @memberships = @guild.invitations
    elsif params[:type].to_i == 2
			@memberships = @guild.requests
		end
  end

  def edit
    render :action => 'edit', :layout => false  
  end
  
  def update
    if @membership.change_role params[:status]
      render :update do |page|
        page << "facebox.close();"
        if @membership.recently_change_role
          page << "$('member_status_#{@membership.id}').innerHTML = '#{@membership.to_s}'"
        end
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = '错误'"
      end
    end 
  end

  def destroy
    if @membership.evict
      render :update do |page|
        page << "$('membership_#{@membership.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end
protected

  def setup
    if ['index'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_owner @guild.president
      @membership = @guild.memberships.find(params[:id])
    end
  end

end
