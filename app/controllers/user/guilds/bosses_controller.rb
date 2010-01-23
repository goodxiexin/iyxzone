class User::Guilds::BossesController < UserBaseController

  def index
    render :partial => 'edit_bosses'
  end

  def new 
  end

  def create
    @boss = @guild.bosses.build(params[:boss])
    if @boss.save
      render :update do |page|
        # insert a new row
      end
    else
      render :update do |page|
        page << "error('发生错误')"
      end
    end
  end
  
  def create_or_update
    if @guild.update_attributes(params[:guild])
      render :partial => 'bosses', :locals => {:guild => @guild}
    else
      flash[:error] = "发生错误"
      redirect_to edit_guild_rules(@guild)
    end
  end

  def destroy
    if @boss.destroy
      render :update do |page|
        page << "$('boss_#{@boss.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('发生错误, 无法删除')"
      end
    end  
  end

protected

  def setup
    if ["index", "new", "create_or_update"].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
    elsif ["destroy"].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
      @boss = @guild.bosses.find(params[:id])
    end
  rescue
    not_found
  end

end
