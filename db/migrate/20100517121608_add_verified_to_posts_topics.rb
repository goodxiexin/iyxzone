class AddVerifiedToPostsTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :verified, :integer, :default => 0
    add_column :posts, :verified, :integer, :default => 0
  end

  def self.down
  end
end
