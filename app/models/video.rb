class Video < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User', :counter_cache => true

  belongs_to :game

  acts_as_shareable

	acts_as_commentable :order => 'created_at ASC'

	acts_as_diggable

  acts_as_list :order => 'created_at', :scope => 'poster_id'
 
	named_scope :hot, :conditions => ["created_at > ? AND privilege != 4", 2.weeks.ago.to_s(:db)], :order => 'digs_count DESC'
	
	named_scope :recent, :conditions => ["created_at > ? AND privilege != 4", 2.weeks.ago.to_s(:db)], :order => 'created_at DESC'

  acts_as_privileged_resources

	acts_as_video

	acts_as_resource_feeds

	has_many :tags, :class_name => 'FriendTag', :as => 'taggable', :dependent => :destroy

	has_many :relative_users, :through => :tags, :source => 'tagged_user'
 
  validate do |video|
    video.errors.add_to_base('标题不能为空') if video.title.blank?
    video.errors.add_to_base('url不能为空') if video.video_url.blank?
    video.errors.add_to_base('游戏类别不能为空') if video.game_id.blank?
    video.errors.add_to_base('标题太长，最长100个字符') if video.title and video.title.length >= 100
  end

  def tags=(ids)
    poster.friends.find(ids).each { |f| tags.build(:poster_id => poster_id, :tagged_user_id => f.id) }
  end

end
