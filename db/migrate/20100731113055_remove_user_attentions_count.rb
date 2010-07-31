class RemoveUserAttentionsCount < ActiveRecord::Migration
  def self.up
    remove_column :users, :attentions_count
  end

  def self.down
  end
end
