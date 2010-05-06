class Admin::PhotosController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @photos = Photo.unverified.paginate :page => params[:page], :per_page => 20, :conditions => {:thumbnail => nil}
    when 1
      @photos = Photo.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @photos = Photo.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @photo.verify
      render :update do |page|
        page << "$('photo_#{@photo.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @photo.unverify
      render :update do |page|
        page << "$('photo_#{@photo.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @photo = Photo.find(params[:id])
    end
  end
  
end
