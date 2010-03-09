class CreateSkins < ActiveRecord::Migration
  def self.up
    create_table :skins do |t|
			t.string :name
			t.string :css_file_name
      t.timestamps
    end
		Skin.create(:name => "aaa", :css_file_name => "testaaa.css")
  end

  def self.down
    drop_table :skins
  end
end
