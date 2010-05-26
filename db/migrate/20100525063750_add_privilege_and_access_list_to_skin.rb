class AddPrivilegeAndAccessListToSkin < ActiveRecord::Migration

  def self.up
    add_column :skins, :category, :string
    add_column :skins, :privilege, :integer, :default => Skin::PUBLIC
    add_column :skins, :access_list, :text
    Skin.update_all("privilege = #{Skin::PUBLIC}")
    Skin.all.each do |s|
      s.category = 'Profile'
      s.save
    end
  end

  def self.down
  end

end
