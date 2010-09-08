class ConvertAvatar < ActiveRecord::Migration
  def self.up
    Avatar.match(:parent_id => nil).all.each do |avatar|
      avatar.thumbnails.destroy_all
      avatar.save
    end
  end

  def self.down
  end
end
