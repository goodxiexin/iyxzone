class User::SharingsController < UserBaseController

  def new
    if SITE_URL =~ /#{@host}/
      # in site url
      @shareable_type = @path.split('/')[1].singularize.camelize
      @shareable_id = @path.split('/')[2]
      @shareable = @shareable_type.constantize.find(@shareable_id)
      @title = @shareable.default_share_title
    else
      if Youku.identify_url(@my_url)
        @video = Video.new
      else
        @link = Link.new 
      end
      @title = (params[:at] == 'outside')? params[:title] : @my_url
    end
    
    if params[:at] == 'outside'
      render :action => 'new_from_outside'
    else
      render :action => 'new'
    end
  end

  def create
    if @host =~ /#{SITE_URL}/
      # in site url
      @shareable_type = @path.split('/')[1].singularize.camelize
      @shareable_id = @path.split('/')[2]
      @shareable = @shareable_type.constantize.find(@shareable_id)
    else
      if Youku.identify_url(@my_url)
        video_params = (params[:video] || {}).merge({:title => params[:title], :description => params[:reason], :poster_id => current_user.id})
        @shareable = Video.create(video_params)
      else
        @shareable = Link.create(params[:link])
      end
    end

    if @shareable.share_by current_user, params[:title], params[:reason]
      render :update do |page|
        if params[:at] == 'outside'
          page << "window.close();"
        elsif params[:at] == 'shares'
          page.redirect_to shares_url(:uid => current_user.id)
        else
          page << "tip('分享成功');"
        end
      end       
    else
      render :update do |page|
        page << "error('同一个资源只能分享一次');"
      end
    end 
  end

  def show
    @link = @share.shareable
    render :action => 'show', :layout => false
  end

protected

  def setup
    if ["show"].include? params[:action]
      @sharing = Sharing.find(params[:id])
      @share = @sharing.share 
      require_external_link @share
    elsif ["new", "create"].include? params[:action]
      @my_url = params[:url]
      @uri = URI.parse(@my_url)
      @host = @uri.host
      @path = @uri.path
    end
  end

  def require_external_link share
    share.shareable_type == 'Link' || render_not_found
  end

  

end
