class Album < ActiveRecord::Base

	belongs_to :poster, :class_name => 'User'

  belongs_to :game

  named_scope :recent, :conditions => "photos_count != 0", :order => 'uploaded_at DESC'

  needs_verification :sensitive_columns => [:title, :description]

  acts_as_random

  acts_as_privileged_resources :owner_field => :poster, :validate_on => "false"

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, album, comment| album.poster == user || comment.poster == user}, 
                      :create_conditions => lambda {|user, album| album.available_for?(user.relationship_with album.poster) }

  attr_readonly :poster_id, :owner_id

  validates_presence_of :owner_id, :message => "不能为空"

  validates_size_of :description, :maximum => 500, :too_long => "最长500字节", :allow_blank => true

  def set_cover photo
    photo_id = photo.nil? ? nil : photo.id
    if cover_id != photo_id
      update_attributes(:cover_id => photo_id)
    end
  end

  def record_upload user, photos
    if !photos.blank?
      update_attribute('uploaded_at', Time.now)
      if user.application_setting.emit_photo_feed? and !is_owner_privilege?
        deliver_feeds :data => {:ids => photos.map(&:id)}
      end
      true
    else
      false
    end
  end

end
