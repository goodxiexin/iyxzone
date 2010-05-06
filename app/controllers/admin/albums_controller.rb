class Admin::AlbumsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @albums = PersonalAlbum.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @albums = PersonalAlbum.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @albums = PersonalAlbum.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @album.verify
      render :update do |page|
        page << "$('album_#{@album.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @album.unverify
      render :update do |page|
        page << "$('album_#{@album.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @album = Album.find(params[:id])
    end
  end
  
end
