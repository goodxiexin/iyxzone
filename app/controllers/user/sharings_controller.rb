class User::SharingsController < UserBaseController

  def new
    if SITE_URL =~ /#{@host}/
      # in site url
      @shareable_type, @shareable_id = Share.get_type_and_id(@path)
      @shareable = @shareable_type.constantize.find(@shareable_id)
      if @shareable.shared_by? current_user
        render :action => 'already_shared'
        return
      elsif !@shareable.is_shareable_by? current_user
        render :action => 'privilege_denied'
        return
      else
        @title = @shareable.default_share_title
      end
    else
      if Youku.identify_url(@my_url)
        @video = Video.new
      else
        @link = Link.new 
      end
      if params[:at] == 'outside'
        @title = params[:title]
      else
        @title = get_page_title
      end
    end
    
    if params[:at] == 'outside'
      render :action => 'new_from_outside'
    else
      render :action => 'new'
    end
  end

  def create
    if SITE_URL =~ /#{@host}/
      # in site url
      @shareable_type, @shareable_id = Share.get_type_and_id @path
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
      render_js_error '发生错误, 该资源可能已经被和谐了'
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
			if params[:url]
				@my_url = params[:url]
				if !@my_url.starts_with? 'http://' and !@my_url.starts_with? 'https'
					@my_url = "http://#{@my_url}"
				end
				@uri = URI.parse(@my_url)
				@host = @uri.host
				@path = @uri.path
			else
				logger.error "WRONG share link"
			end
    end
  end

  def require_external_link share
    share.shareable_type == 'Link' || render_not_found
  end

  def get_page_title
    require 'iconv'
    resp, body = fetch(@my_url)
    if resp.is_a? Net::HTTPSuccess
      body =~ /<title>(.*?)<\/title>/
      title = $1
      content_type = resp['Content-Type']
      content_type =~ /charset=(.*)/
      charset = $1 || 'gb2312'
      Iconv.iconv('utf8', charset, title)
    else
      @my_url
    end
  rescue
    # 或者是除了200和300以外的返回码，或者就是redirect太多
    # 凡此种种，皆以下法导入神通
    @my_url
  end

  def fetch(uri_str, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    resp, body = Net::HTTP.get_response(URI.parse(uri_str))
    case resp
    when Net::HTTPSuccess     then [resp, body]
    when Net::HTTPRedirection then fetch(resp['location'], limit - 1)
    when Net::HTTPMovedPermanently then fetch(resp['location'], limit - 1)
    else
      raise ArgumentError, 'invalid url'
    end
  end

end
