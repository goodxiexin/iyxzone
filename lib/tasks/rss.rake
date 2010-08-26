namespace :rss do

  task :import => :environment do
    RssFeed.all.each do |rss|
      new_items = rss.synchronize #r = rss.parse
      new_items.each do |item|
        Blog.create :poster_id => rss.user_id, :title => item.title, :content => item.description
      end
    end
  end

end
