class Admin::GuildsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @guilds = Guild.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @guilds = Guild.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @guilds = Guild.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @guild.verify
      render :update do |page|
        page << "$('guild_#{@guild.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @guild.unverify
      render :update do |page|
        page << "$('guild_#{@guild.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @guild = Guild.find(params[:id])
    end
  end
  
end
