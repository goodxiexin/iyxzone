class User::HomeController < UserBaseController

  layout 'app'

  FirstFetchSize = 10

  FetchSize = 10

  FeedCategory = ['all', 'status', 'blog', 'all_album_related', 'video', 'sharing']

  def show
    @feed_deliveries = current_user.feed_deliveries.limit(FirstFetchSize).order('created_at DESC')
    @first_fetch_size = FirstFetchSize
    @viewings = current_user.profile.viewings.prefetch([{:viewer => :profile}]).limit(6)
    @notices = current_user.notices.unread.limit(10)
    @news_list, @rich_news = News.daily
    @status = current_user.statuses.nonblocked.first # latest status
    @friend_suggestions = FriendSuggestion.random(:limit => 6, :conditions => {:user_id => current_user.id}, :include => [{:suggested_friend => :profile}])
  end

  def feeds
    @feed_deliveries = eval("current_user.#{@type}_feed_deliveries").limit(FirstFetchSize).order('created_at DESC')
    @fetch_size = FetchSize
  end

  def more_feeds
    @feed_deliveries = eval("current_user.#{@type}_feed_deliveries").offset(FirstFetchSize + FetchSize * params[:idx].to_i).limit(FirstFetchSize).order('created_at DESC')
		@fetch_size = FetchSize
  end

protected

  def setup
    if ['feeds', 'more_feeds'].include? params[:action]
      @type = FeedCategory[params[:type].to_i]
    end
  end

end
