class RssFeedObserver < ActiveRecord::Observer

  # 保证每个用户只有1个rss feed
  def before_create rss
    old_feed = RssFeed.find_by_user_id rss.user_id
    old_feed.destroy if old_feed
  end

end
