class Video < ActiveRecord::Base

  belongs_to :poster, :class_name => 'User'

  belongs_to :game

  named_scope :hot, :conditions => ["created_at > ? AND privilege != 4", 2.weeks.ago.to_s(:db)], :order => 'digs_count DESC'

  named_scope :recent, :conditions => ["created_at > ? AND privilege != 4", 2.weeks.ago.to_s(:db)], :order => 'created_at DESC'

  acts_as_friend_taggable :delete_conditions => lambda {|user, video| video.poster == user },
                          :create_conditions => lambda {|user, video| video.poster == user }

  acts_as_shareable

	acts_as_diggable :create_conditions => lambda {|user, video| video.privilege != 4 or video.poster == user}

  acts_as_list :order => 'created_at', :scope => 'poster_id'
 
  acts_as_privileged_resources

	acts_as_video

	acts_as_resource_feeds

  acts_as_commentable :order => 'created_at ASC',
                      :delete_conditions => lambda {|user, video, comment| user == video.poster || user == comment.poster},  
                      :create_conditions => lambda {|user, video| (user == video.poster) || (video.privilege == 1) || (video.privilege == 2 and (video.poster.has_friend? user or video.poster.has_same_game_with? user)) || (video.privilege == 3 and video.poster.has_friend? user) || false} 
 
  def validate
    # check title
    if title.blank?
      errors.add_to_base('标题不能为空')
      return false
    elsif title.length > 100
      errors.add_to_base('标题最长100个字符')
      return false
    end

    # check description
    if !description.blank? and description.length > 10000
      errors.add_to_base('介绍不能超过10000个字符')
      return false
    end

    # check url
    if video_url.blank?
      errors.add_to_base('url不能为空')
      return false
    end

    # check game
    if game_id.blank? 
      errors.add_to_base('游戏类别不能为空')
    elsif Game.find(:first, :conditions => {:id => game_id}).nil?
      errors.add_to_base('游戏不存在')
    end
  end

end
