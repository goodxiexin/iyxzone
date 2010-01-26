class User::Guilds::GearsController < UserBaseController

  def index
    render :partial => 'edit_gears'
  end

  def new
  end

  def create
    @gear = @guild.gears.build(params[:gear])
    if @gear.save
      render :update do |page|
        # insert a line
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def create_or_update
    if @guild.update_attributes(params[:guild])
      @guild.reload # in case some gears are not saved properly
      render :partial => 'gears', :locals => {:guild => @guild}
    else
      flash[:error] = "发生错误"
      redirect_to edit_guild_rules(@guild)
    end
  end

  def destroy
    if @gear.destroy
      render :partial => 'gears', :locals => {:guild => @guild}
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ["index", "new", "create_or_update"].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
    elsif ["destroy"].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
      @gear = @guild.gears.find(params[:id])
    end
  rescue
    not_found
  end 

end
