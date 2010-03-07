class User::Guilds::GearsController < UserBaseController

  def index
    render :partial => 'edit_gears'
  end

  def create
    gear_params = (params[:gear] || {}).merge({:guild_id => @guild.id})
    @gear = Gear.new(gear_params)
    if @gear.save
      render :json => @gear
    else
      render :json => {:errors => @gear.errors}
    end
  end

  def create_or_update
    if @guild.update_attributes(params[:guild])
      @guild.reload
      render :partial => 'bosses', :locals => {:guild => @guild}
    else
      flash[:error] = "发生错误"
      redirect_to edit_guild_rules(@guild)
    end
  end

protected

  def setup
    if ["index", "create", "create_or_update"].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      require_owner @guild.president
    end
  end 

end
