class Admin::PhotoTagsController < AdminBaseController

  def index
    @photo_tags = Photo_tag.unverified.paginate :page => params[:page], :per_page => 20
  end
  
  def accept
    @photo_tags = Photo_tag.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @photo_tags = Photo_tag.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  # accept
  def verify
    if @photo_tag.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @photo_tag.unveirfy
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @photo_tag = Photo_tag.find(params[:id])
    end
  end
  
end
