class Video < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids}}}

  named_scope :hot, :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => 'digs_count DESC, created_at DESC'

  named_scope :recent, :conditions => ["created_at > ?", 2.weeks.ago.to_s(:db)], :order => 'created_at DESC'

  needs_verification :sensitive_columns => [:title, :description] 

  acts_as_random
 
  acts_as_friend_taggable 

	acts_as_diggable :create_conditions => lambda {|user, video| video.available_for? user.relationship_with(video.poster)}

  acts_as_list :order => 'created_at', :scope => 'poster_id'
 
  acts_as_privileged_resources :owner_field => :poster

	acts_as_video

	acts_as_resource_feeds :recipients => lambda {|video| 
    poster = video.poster
    friends = poster.friends.find_all {|f| f.application_setting.recv_video_feed?}
    [poster.profile, video.game] + poster.all_guilds + friends + (poster.is_idol ? poster.fans : [])
  }

  acts_as_commentable :order => 'created_at ASC', :delete_conditions => lambda {|user, video, comment| user == video.poster || user == comment.poster}, :create_conditions => lambda {|user, video| video.available_for? user.relationship_with(video.poster) }

  # video url 和 game_id 还有 poster_id 一经创建无法修改
  attr_readonly :video_url, :game_id, :poster_id

  validates_size_of :title, :within => 1..100

  validates_size_of :description, :maximum => 1000

  validates_presence_of :poster_id

  validates_presence_of :video_url

  validate_on_create :game_is_valid

protected

  def game_is_valid
    if game.blank?
      errors.add('game_id', "不存在")
    elsif poster and !poster.has_game?(game)
      errors.add('game_id', "该用户没有这个游戏")
    end
  end

end
