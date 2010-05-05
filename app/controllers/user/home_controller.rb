class User::HomeController < UserBaseController

  layout 'app'

  FirstFetchSize = 10

  FetchSize = 10

  FeedCategory = ['status', 'blog', 'all_album_related', 'video', 'sharing']

  def show
    @feed_deliveries = current_user.feed_deliveries.all(:limit => FirstFetchSize, :order => "created_at DESC", :include => [{:feed_item => :originator}])
    @first_fetch_size = FirstFetchSize
  
    @viewings = current_user.profile.viewings.all(:include => [{:viewer => :profile}], :limit => 6)

    @friend_suggestions = FriendSuggestion.random(:limit => 6, :conditions => {:user_id => current_user.id}, :include => [{:suggested_friend => :profile}])
    
    @notices = current_user.notices.unread.all(:limit => 10, :include => [:producer])

    @news_list = News.all(:conditions => ["created_at > ? and created_at < ?", 1.day.ago.beginning_of_day, Time.now], :limit => 4, :order => 'created_at DESC')
  end

  def feeds
    if params[:type].blank?
      @feed_deliveries = current_user.feed_deliveries.find(:all, :limit => FirstFetchSize,  :order => "created_at DESC")
    else
      @feed_deliveries = eval("current_user.#{FeedCategory[params[:type].to_i]}_feed_deliveries.find(:all, :limit => FirstFetchSize,  :order => 'created_at DESC')")
    end
  end

  def more_feeds
    if params[:type].blank?
      @feed_deliveries = current_user.feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize*params[:idx].to_i, :limit => FetchSize,  :order => "created_at DESC")
			@fetch_size = FetchSize
    else
      @feed_deliveries = eval("current_user.#{FeedCategory[params[:type].to_i]}_feed_deliveries.find(:all, :offset => FirstFetchSize + FetchSize*params[:idx].to_i, :limit => FirstFetchSize, :order => 'created_at DESC')")
			@fetch_size = FetchSize
    end
  end

end
