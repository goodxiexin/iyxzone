class User::MiniLinksController < UserBaseController

  def show
  end

  # 只创建视频类的
  def create
    if params[:url] =~ MiniLink::UrlReg
      @link = MiniLink.find_by_proxy_url params[:url]
    else
      @link = MiniLink.find_by_url params[:url]
    end

    if @link.nil?
      @link = MiniLink.create :url => params[:url]
      if @link.is_video?
        render :json => {:video => 1, :url => @link.proxy_url}
      else
        @link.destroy
        render :json => {:video => 0, :url => params[:url]}
      end
    else
      if @link.is_video?
        render :json => {:video => 1, :url => @link.proxy_url}
      else
        render :json => {:video => 0, :url => @link.url}
      end
    end
  end

protected

  def setup
  end

end
