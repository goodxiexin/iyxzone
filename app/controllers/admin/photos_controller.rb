class Admin::PhotosController < AdminBaseController

  def index
    @photos = Photo.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @photos = Photo.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @photos = Photo.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  # accept
  def verify
    if @photo.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @photo.unveirfy
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @photo = Photo.find(params[:id])
    end
  end
  
end
