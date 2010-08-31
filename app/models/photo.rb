require 'mime/types'

class Photo < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

	belongs_to :album

	has_many :relative_users, :through => :tags, :source => 'tagged_user'

	named_scope :hot, :conditions => ["parent_id IS NULL and created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC, created_at DESC"

  acts_as_privileged_resources :owner_field => :poster, :validate_on => "false"

  needs_verification :sensitive_columns => [:notation]

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, photo, comment| photo.album.poster == user || comment.poster == user},
                      :create_conditions => lambda {|user, photo| photo.available_for?(user.relationship_with photo.album.poster)}
 
  acts_as_diggable :create_conditions => lambda {|user, photo| photo.available_for? user.relationship_with(photo.poster)}

  def is_cover?
    album.cover_id == id
  end

  def is_cover= is_cover
    @cover_action = (is_cover.to_i == 1) ? :recently_set_cover : :recently_unset_cover
  end

  def recently_set_cover?
    @cover_action == :recently_set_cover
  end

  def recently_unset_cover?
    @cover_action == :recently_unset_cover
  end

  def clear_cover_action
    @cover_action = nil
  end

	def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end
  
  validates_size_of :notation, :maximum => 1000, :allow_blank => true

  validates_presence_of :album_id, :if => "thumbnail.blank?", :on => :create

  attr_readonly :poster_id

end
