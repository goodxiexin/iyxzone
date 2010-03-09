class Admin::GuildsController < AdminBaseController

  def index
    @guilds = Guild.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @guilds = Guild.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @guilds = Guild.rejected.paginate :page => params[:page], :per_page => 20
  end
  
  def show
  end

  def destroy
  end

  # accept
  def verify
    if @guild.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @guild.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @guild = Guild.find(params[:id])
    end
  end
  
end
