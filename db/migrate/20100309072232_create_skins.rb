class CreateSkins < ActiveRecord::Migration
  def self.up
    create_table :skins do |t|
			t.string :name, :null => false
			t.string :css, :null => false
			t.string :thumbnail, :default => "missing"
      t.timestamps
    end
		Skin.create(:name => "default", :css => "home", :thumbnail => "default.png")
		Skin.create(:name => "wow", :css => "wow", :thumbnail => "default.png")
		Skin.create(:name => "3", :css => "3", :thumbnail => "default.png")
		Skin.create(:name => "4", :css => "4", :thumbnail => "default.png")
		Skin.create(:name => "5", :css => "5", :thumbnail => "default.png")
		Skin.create(:name => "6", :css => "6", :thumbnail => "default.png")
		Skin.create(:name => "7", :css => "7", :thumbnail => "default.png")
		Skin.create(:name => "8", :css => "8", :thumbnail => "default.png")
		Skin.create(:name => "9", :css => "9", :thumbnail => "default.png")
		
  end

  def self.down
    drop_table :skins
  end
end
