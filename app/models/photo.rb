require 'mime/types'

class Photo < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

	belongs_to :album

	has_many :relative_users, :through => :tags, :source => 'tagged_user'

	named_scope :hot, :conditions => ["parent_id IS NULL and created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC, created_at DESC"

  needs_verification :sensitive_columns => [:notation]

	acts_as_privileged_resources :owner_field => :poster, :validate_on => "false"

	acts_as_resource_feeds :recipients => lambda {|photo| 
    poster = photo.album.poster
    poster.friends.find_all{|f| f.application_setting.recv_photo_feed?} + (poster.is_idol ? poster.fans : [])
  }

  acts_as_shareable :path_reg => [/\/personal_photos\/([\d]+)/, /\/event_photos\/([\d]+)/, /\/guild_photos\/([\d]+)/, /\/avatars\/([\d]+)/],
                    :default_title => lambda {|photo| "相册#{photo.album.title}的照片"},
                    :create_conditions => lambda {|user, photo| !photo.is_owner_privilege?}

  acts_as_diggable :create_conditions => lambda {|user, photo| !photo.is_owner_privilege?}

  def is_cover?
    album.cover_id == id
  end

	def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end

  attr_accessor :cover

  def self.migrate opts={}
    from = opts[:from]
    to = opts[:to]
    return if from.nil? or to.nil?
    Photo.update_all("album_id = #{to.id}, privilege = #{to.privilege}", {:album_id => from.id})
    to.update_attribute(:photos_count, to.photos_count + from.photos_count)
  end

end
