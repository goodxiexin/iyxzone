class CreateAttentions < ActiveRecord::Migration
  def self.up
    create_table :attentions do |t|
      t.integer :attentionable_id
      t.string :attentionable_type
      t.integer :follower_id
      t.timestamps
    end
  end

  def self.down
    drop_table :attentions
  end
end
