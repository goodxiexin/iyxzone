require "open-uri"
require "rss/1.0"
require "rss/2.0"

class User::RssFeedsController < UserBaseController

  layout 'app'
  
  def index
    @rss_feed = current_user.rss_feed
  end

  def show
    
    
  end

  def create
    begin
      @rss = get_blogs params[:rsslink]
      logger.error @rss.inspect
    rescue SocketError,Errno::ENOENT
      flash[:notice] = "目标地址暂时不可用"
      @rss = nil
      redirect_to rss_feeds_path
    rescue RSS::NotWellFormedError
      flash[:notice] = "不是标准的RSS链接"
      @rss = nil
      redirect_to rss_feeds_path
    else
      render :create
    end
  end

  def new
   
  end
#protected
  #地址不对可能是SocketError
  #parse错误是RSS::NotWellFormedError
  def get_blogs source
    content = open(source).read
    RSS::Parser.parse(content)
  end

end
