require 'mime/types'

class Photo < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

	belongs_to :album

	has_many :relative_users, :through => :tags, :source => 'tagged_user'

	named_scope :hot, :conditions => ["parent_id IS NULL and created_at > ? and privilege != 4", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC"

  needs_verification

	acts_as_privileged_resources :owner_field => :poster

	acts_as_resource_feeds

  acts_as_shareable :path_reg => [/\/personal_photos\/([\d]+)/, /\/event_photos\/([\d]+)/, /\/guild_photos\/([\d]+)/, /\/avatars\/([\d]+)/],
                    :default_title => lambda {|photo| "相册#{photo.album.title}的照片"},
                    :create_conditions => lambda {|user, photo| photo.privilege != 4 }

  acts_as_diggable :create_conditions => lambda {|user, photo| (photo.type != 'PersonalPhoto' and photo.type != 'Avatar') or photo.privilege != 4}

  def is_cover?
    album.cover_id == id
  end

	def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end

  attr_accessor :cover

end
