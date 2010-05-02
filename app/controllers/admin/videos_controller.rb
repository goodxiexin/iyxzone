class Admin::VideosController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @videos = Video.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @videos = Video.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @videos = Video.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @video.verify
      render :update do |page|
        page << "$('video_#{@video.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @video.unverify
      render :update do |page|
        page << "$('video_#{@video.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @video = Video.find(params[:id])
    end
  end
  
end
