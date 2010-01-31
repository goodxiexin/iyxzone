class News < ActiveRecord::Base
  belongs_to :game
 # belongs_to :poster, :class_name => 'User'

  attr_readonly :poster_id
  acts_as_commentable :order => 'created_at ASC',
    :delete_conditions => lambda { |user, news, comment| news.poster == user || comment.poster == user }
  acts_as_shareable
  acts_as_viewable

  def validate
    #check game
    if game_id.blank?
      errors.add_to_base('没有游戏')
    elsif Game.find(:first, :conditions => {:id => game_id}).nil?
      errors.add_to_base('游戏不存在')
    end

    #check news type
    if news_type.blank?
      errors.add_to_base('没有新闻种类')
    end

    #check data
    if data.blank?
      errors.add_to_base('没有内容')
    end
  end
end
