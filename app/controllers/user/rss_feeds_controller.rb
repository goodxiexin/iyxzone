class User::RssFeedsController < UserBaseController

  layout 'app'

  def new
    @rss = current_user.rss_feed
  end

  def show
    @r = @rss.parse
    @channel = @r.channel
    @items = @r.items
  rescue RssFeed::NotRssError 
    @rss.destroy
    flash[:error] = "不是合法的rss"
    redirect_to new_rss_feed_url
  end

  def create
    @rss = RssFeed.new params[:rss_feed].merge({:user_id => current_user.id, :last_update => Time.now})

    if @rss.save
      render :json => {:code => 1, :id => @rss.id}
    else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @rss.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ['show', 'destroy'].include? params[:action]
      @rss = RssFeed.find(params[:id])
    end
  end

end
