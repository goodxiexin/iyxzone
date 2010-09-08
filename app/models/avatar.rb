require 'RMagick'

class Avatar < Photo

  # max 基本只用在个人主页
  has_attachment :content_type => :image, :storage => :file_system, :max_size => 8.megabytes, :thumbnails => {:max => 'crop: 230x230', :large => '100x100>', :clarge => 'crop: 100x100', :cmedium => 'crop: 50x50', :csmall => 'crop: 25x25'}

  validates_as_attachment

  acts_as_photo_taggable :delete_conditions => lambda {|user, photo, album| album.poster == user}, 
                         :create_conditions => lambda {|user, photo, album| album.poster == user || album.poster.has_friend?(user)},
                         :candidates => lambda {|tagger, photo, album| [tagger] + tagger.friends}

  acts_as_resource_feeds :recipients => lambda {|photo| 
    poster = photo.album.poster
    friends = poster.friends.all(:select => "users.id, users.application_setting").find_all{|f| f.application_setting.recv_photo_feed?}
    fans = poster.is_idol ? poster.fans.all(:select => "users.id") : []
    (friends + fans).uniq
  }
  
  attr_readonly :album_id

  def crop lcoords, scoords
    orig_img = Magick::Image.read(File.join('public', public_filename)).first
    thumb_img = orig_img.crop lcoords[:x1].to_i, lcoords[:y1].to_i, (lcoords[:x2].to_i - lcoords[:x1].to_i), (lcoords[:y2].to_i - lcoords[:y1].to_i)

    # generate max thumbnail
    max_thumb = thumb_img.resize 230, 230
    max_thumb.write File.join('public', public_filename(:max))

    # generate clarge thumbnail
    clarge_thumb = thumb_img.resize 100, 100
    clarge_thumb.write File.join('public', public_filename(:clarge))  
    
    thumb_img = orig_img.crop scoords[:x1].to_i, scoords[:y1].to_i, (scoords[:x2].to_i - scoords[:x1].to_i), (scoords[:y2].to_i - scoords[:y1].to_i)

    # generate cmedium thumbnail
    cmedium_thumb = thumb_img.resize 50, 50
    cmedium_thumb.write File.join('public', public_filename(:cmedium))

    # generate csmall thumbnail
    csmall_thumb = thumb_img.resize 25, 25
    csmall_thumb.write File.join('public', public_filename(:csmall))  

    # deliver feeds if necessary
    deliver_feeds if poster.application_setting.emit_photo_feed?
    return true
  rescue
    return false
  end

end
