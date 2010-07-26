class AddFreqToMiniTopic < ActiveRecord::Migration
  def self.up
    remove_column :mini_topics, :freq
    add_column :mini_topics, :freq_in_chinese, :integer, :default => 0
    add_column :mini_topics, :freq_in_site, :integer, :default => 0
  end

  def self.down
  end
end
