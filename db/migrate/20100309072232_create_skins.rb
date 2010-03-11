class CreateSkins < ActiveRecord::Migration
  def self.up
    create_table :skins do |t|
			t.string :name, :null => false
			t.string :css_file_name, :null => false
			t.string :thumbnail_file_name, :default => "missing"
      t.timestamps
    end
		Skin.create(:name => "default", :css_file_name => "home", :thumbnail_file_name => "default")
		Skin.create(:name => "wow", :css_file_name => "wow", :thumbnail_file_name => "default")
		Skin.create(:name => "3", :css_file_name => "3", :thumbnail_file_name => "default")
		Skin.create(:name => "4", :css_file_name => "4", :thumbnail_file_name => "default")
		Skin.create(:name => "5", :css_file_name => "5", :thumbnail_file_name => "default")
		Skin.create(:name => "6", :css_file_name => "6", :thumbnail_file_name => "default")
		Skin.create(:name => "7", :css_file_name => "7", :thumbnail_file_name => "default")
		Skin.create(:name => "8", :css_file_name => "8", :thumbnail_file_name => "default")
		Skin.create(:name => "9", :css_file_name => "9", :thumbnail_file_name => "default")
		
  end

  def self.down
    drop_table :skins
  end
end
