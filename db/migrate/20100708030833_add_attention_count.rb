class AddAttentionCount < ActiveRecord::Migration
  def self.up
    add_column :users, :attentions_count, :integer, :default => 0
    add_column :guilds, :attentions_count, :integer, :default => 0
  end

  def self.down
    remove_column :users, :attentions_count
    remove_column :guilds, :attentions_count
  end
end
