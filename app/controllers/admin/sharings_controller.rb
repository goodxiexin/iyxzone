class Admin::SharingsController < AdminBaseController

  def index
    @sharings = Sharing.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @sharings = Sharing.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @sharings = Sharing.rejected.paginate :page => params[:page], :per_page => 20
  end
  
  def show
  end

  def destroy
  end

  # accept
  def verify
    if @sharing.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @sharing.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @sharing = Sharing.find(params[:id])
    end
  end
  
end
