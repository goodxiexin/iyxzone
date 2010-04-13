class CreateSkins < ActiveRecord::Migration
  def self.up
    create_table :skins do |t|
			t.string :name, :null => false
			t.string :css, :null => false
			t.string :thumbnail, :default => "missing"
      t.timestamps
    end
		Skin.create(:name => "default", :css => "home", :thumbnail => "default.png")
		Skin.create(:name => "wow", :css => "wow", :thumbnail => "wow.jpg")
  end

  def self.down
    drop_table :skins
  end
end
