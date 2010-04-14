class AddRecipientIdInPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :recipient_id, :integer
  end

  def self.down
    remove_column :posts, :recipient_id
  end
end
