class CreateRssFeeds < ActiveRecord::Migration
  def self.up
    create_table :rss_feeds, :force => true do |t|
      t.integer :user_id
      t.string :link
      t.datetime :last_update

      t.timestamps
    end
  end

  def self.down
    drop_table :rss_feeds
  end
end
