class CreateVipSkins < ActiveRecord::Migration
  def self.up
    create_table :vip_skins do |t|
      t.integer :user_id
      t.integer :skin_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vip_skins
  end
end
