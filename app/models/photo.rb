require 'mime/types'

class Photo < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

	belongs_to :album

	has_many :relative_users, :through => :tags, :source => 'tagged_user'

	named_scope :hot, :conditions => ["parent_id IS NULL and created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC, created_at DESC"

  needs_verification :sensitive_columns => [:notation]

	acts_as_privileged_resources :owner_field => :poster, :validate_on => "false"

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, photo, comment| photo.album.poster == user || comment.poster == user},
                      :create_conditions => lambda {|user, photo| photo.available_for?(user.relationship_with photo.album.poster)}
 
  acts_as_shareable :path_reg => [/\/avatars\/([\d]+)/, /\/personal_photos\/([\d]+)/, /\/event_photos\/([\d]+)/, /\/guild_photos\/([\d]+)/],
                    :default_title => lambda {|photo| "#{photo.album.title}的照片"},
                    :create_conditions => lambda {|user, photo| photo.available_for? user.relationship_with(photo.poster)}

  acts_as_diggable :create_conditions => lambda {|user, photo| photo.available_for? user.relationship_with(photo.poster)}

  attr_readonly :poster_id, :game_id

  def is_cover?
    album.cover_id == id
  end

  def is_cover= is_cover
    @is_cover = is_cover #album.set_cover self if is_cover
  end

  after_save :set_album_cover

  def set_album_cover
    if @is_cover
      album.set_cover self
    end
  end

	def swf_uploaded_data=(data)
    data.content_type = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end
  
  def partitioned_path(*args)
    dir = (attachment_path_id / 10000).to_s
    sub_dir = (attachment_path_id % 10000).to_s
    [dir, sub_dir] + args
  end

  validates_size_of :notation, :maximum => 1000, :too_long => "最多1000个字符", :allow_blank => true

  validates_presence_of :album_id, :if => "thumbnail.blank?", :on => :create

  #validate_on_create :album_is_valid

  attr_readonly :album_id, :poster_id, :game_id, :privilege

protected

  def album_is_valid
    errors.add(:album_id, "不存在") if album.blank?
  end

end
