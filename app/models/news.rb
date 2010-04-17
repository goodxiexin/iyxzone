class News < ActiveRecord::Base

  belongs_to :game

  belongs_to :poster, :class_name => 'User'

  named_scope :text, :conditions => ["news_type = '文字'"], :order => "created_at DESC"

  named_scope :pic, :conditions => ["news_type = '图片'"], :order => "created_at DESC"

  named_scope :video, :conditions => ["news_type = '视频'"], :order => "created_at DESC"

  attr_readonly :poster_id
  
  acts_as_commentable :order => 'created_at ASC', :recipient_required => false
  
  acts_as_diggable  
  
  acts_as_shareable :default_title => lambda {|news| news.title}, :path_reg => /\/news\/([\d]+)/
  
  acts_as_viewable

  validates_presence_of :title, "没有标题"

  validates_presence_of :game_id, "没有游戏"

  validate :game_is_valid

  validates_presence_of :news_type, "没有类型"

  validates_inclusion_of :news_type, :in => ['文字', '图片', '新闻'], :message => "只能是文字、图片或者新闻"

  validates_presence_of :data, :message => "没有内容"

protected

  def game_is_valid
    return if game_id.blank?
    errors.add(:game_id, "不存在") unless Game.exists? game_id
  end

end
