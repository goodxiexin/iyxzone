class AddTitleAndDirToSkin < ActiveRecord::Migration
  def self.up
	begin
    add_column :skins, :directory, :string
	rescue
		puts "column exist, just ignore"
	end
		Skin.reset_column_information
		Skin.update_all("directory = name")
		h = {'default' => '默认', 'wow' => '魔兽世界', 'aion' => '永恒之塔', 'dnf' => '地下城与勇士', 'popkart' => '跑跑卡丁车', 'wenxin' => '温馨'}
		h.each do |k,v|
			s = Skin.find_by_name(k)
			s.name = v
			s.save
		end
		Skin.create(:name => "波斯王子", :css => "princeofpersia", :thumbnail => "princeofpersia.png", :category => "Profile", :privilege => 0,
								:access_list => nil, :directory => "princeofpersia")
		Skin.create(:name => "大话西游3", :css => "xy3", :thumbnail => "xy3.png", :category => "Profile", :privilege => 0,
								:access_list => nil, :directory => "xy3")
		Skin.create(:name => "海涛专用", :css => "esports-haitao", :thumbnail => "esports-haitao.png", :category => "Profile", :privilege => 1,
								:access_list => [784], :directory => "dota")

  end

  def self.down
	begin
    remove_column :skins, :directory
	rescue
		puts "column not exist, just ignore"
	end
		h = {'default' => '默认', 'wow' => '魔兽世界', 'aion' => '永恒之塔', 'dnf' => '地下城与勇士', 'popkart' => '跑跑卡丁车', 'wenxin' => '温馨'}
		h.each do |k,v|
			s = Skin.find_by_name(v)
			s.name = k
			s.save
		end
		Skin.delete_all("name = '波斯王子' OR name = '大话西游3' OR name = '海涛专用'")
  end
end
