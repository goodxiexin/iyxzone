class Admin::VideosController < AdminBaseController

  def index
    @videos = Video.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @videos = Video.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @videos = Video.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  # accept
  def verify
    if @video.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @video.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @video = Video.find(params[:id])
    end
  end
  
end
