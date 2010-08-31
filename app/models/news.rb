class News < ActiveRecord::Base

  named_scope :type, lambda {|name|
    if name == 'all'
      {}
    elsif name == 'picture'
      {:conditions => {:news_type => 'picture'}}
    elsif name == 'video'
      {:conditions => {:news_type => 'video'}}
    elsif name == 'text'
      {:conditions => {:news_type => 'text'}}
    end
  }

  named_scope :within, lambda {|from, to| {:conditions => ["created_at > ? AND created_at < ?", from, to]}}

  named_scope :hot, :conditions => ["created_at > ?", 1.weeks.ago.to_s(:db)], :order => "viewings_count DESC, created_at DESC"

  has_many :pictures, :class_name => 'NewsPicture' # only valid for picture news

  related_to_game

  belongs_to :poster, :class_name => 'User' # this must be an admin

  acts_as_commentable :order => 'created_at ASC', :recipient_required => false,
                      :delete_conditions => lambda {|user, news, comment| user.is_admin? }

  acts_as_viewable

  acts_as_abstract :columns => [:data], :if => "news_type == 'text'"

  acts_as_diggable

  acts_as_video

  acts_as_random

  validates_size_of :title, :within => 1..300

  validates_inclusion_of :news_type, :in => ['picture', 'video', 'text']

  def self.daily 
    news = self.all(:conditions => ['created_at > ?', 1.days.ago], :order => 'created_at DESC', :limit => 4)
    picture_news = news.select {|n| n.news_type == 'picture'}.first
    video_news = news.select {|n| n.news_type == 'video'}.first
    if picture_news
      [news - [picture_news], picture_news]
    elsif video_news
      [news - [video_news], video_news]
    else
      [news, nil]
    end
  end

end
