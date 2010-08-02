class User::HomeController < UserBaseController

  layout 'app'

  def show
    # mini_blogs
    @mini_blogs = MiniBlog.category(:text).limit(3).all
    @time, @topics = MiniTopic.hot
    @topics = @topics[0..3]

    @fetch_size = 20
    @feed_deliveries = current_user.feed_deliveries.limit(@fetch_size).all
    @viewings = current_user.profile.viewings.prefetch([{:viewer => :profile}]).limit(6)
    @notices = current_user.notices.unread.limit(10).all
    @news_list, @rich_news = News.daily
    @friend_suggestions = FriendSuggestion.random(:limit => 6, :conditions => {:user_id => current_user.id}, :include => [{:suggested_friend => :profile}])
  end

end
