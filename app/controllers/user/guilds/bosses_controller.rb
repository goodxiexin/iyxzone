class User::Guilds::BossesController < UserBaseController

  def index
    render :partial => 'edit_bosses'
  end

  def create
    boss_params = (params[:boss] || {}).merge({:guild_id => @guild.id})
    @boss = Boss.new(boss_params)
    if @boss.save
      render :json => @boss
    else
      render :json => {:errors => @boss.errors}
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
