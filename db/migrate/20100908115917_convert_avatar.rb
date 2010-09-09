require 'RMagick'

class ConvertAvatar < ActiveRecord::Migration
  def self.up
    Avatar.match(:parent_id => nil).all.each do |avatar|
      orig_img = Magick::Image.read(File.join('public', avatar.public_filename)).first
      max_thumb = orig_img.crop_resize 230, 230
      max_thumb.write File.join('public', avatar.public_filename(:max))
      name = "#{avatar.filename.split('.').first}_max.#{avatar.filename.split('.').last}"
      Avatar.create :album_id => nil, :parent_id => avatar.id, :content_type => avatar.content_type, :size => avatar.size, :width => 230, :height => 230, :filename => name, :thumbnail => "max"
      puts "#{avatar.id}: #{name} created"
    end
  end

  def self.down
  end
end
