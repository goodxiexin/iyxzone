# 之所以叫sharings是因为为了兼容以前有分享时候的那个站外分享功能
class User::SharingsController < UserBaseController

  def new
    if params[:url] =~ MiniLink::UrlReg
      @link = MiniLink.find_by_proxy_url params[:url]
    else
      @link = MiniLink.find_by_url params[:url]
    end

    if @link.nil?
      @link = MiniLink.create :url => params[:url]
    end
  end

end
