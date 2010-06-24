class Blog < ActiveRecord::Base

  belongs_to :game

	belongs_to :poster, :class_name => 'User'

  has_many :images, :class_name => 'BlogImage', :dependent => :delete_all

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids, :draft => false}}}

  named_scope :hot, :conditions => ["draft = 0 AND created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC, created_at DESC"

  named_scope :recent, :conditions => ["draft = 0 AND created_at > ?", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"
  
  needs_verification :sensitive_columns => [:content, :title]

  acts_as_random
  
  acts_as_friend_taggable 

  acts_as_viewable

	acts_as_diggable :create_conditions => lambda {|user, blog| !blog.draft and blog.available_for?(user.relationship_with(blog.poster))}

  acts_as_resource_feeds :recipients => lambda {|blog| 
    poster = blog.poster
    [poster.profile] + poster.all_guilds + poster.friends.find_all {|f| f.application_setting.recv_blog_feed?} + (poster.is_idol ? poster.fans : [])
  }
  
  acts_as_shareable :path_reg => /\/blogs\/([\d]+)/, 
                    :default_title => lambda {|blog| blog.title}, 
                    :create_conditions => lambda {|user, blog| !blog.draft and blog.available_for?(user.relationship_with(blog.poster))}

  acts_as_list :order => 'created_at', :scope => 'poster_id', :conditions => {:draft => false}

  acts_as_privileged_resources :owner_field => :poster

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, blog, comment| user == blog.poster || user == comment.poster}, 
                      :create_conditions => lambda {|user, blog| !blog.draft and blog.available_for?(user.relationship_with(blog.poster))}

  acts_as_abstract :columns => [:content]

  # poster_id 和 game_id 一经创建无法修改
  attr_readonly :poster_id, :game_id

  validates_size_of :title, :within => 1..100, :too_long => "最长100个字节", :too_short => "最短1个字节"

  validates_presence_of :poster_id, :message => "不能为空", :on => :create

  validates_size_of :content, :within => 1..10000, :too_long => "最长10000字节", :too_short => "最短1个字节"

  validate_on_create :game_is_valid

  after_save :update_blog_images

  def self.test_limit
    with_scope :find => {:limit => 5} do
      puts Blog.count
    end
  end

protected

  def game_is_valid
    errors.add('game_id', "不存在") if game.blank?
    errors.add('game_id', "该用户没有这个游戏") if poster and !poster.has_game?(game)
  end

  def update_blog_images
    ids = []
    doc = Nokogiri::HTML(self.content)
    doc.xpath("//img[starts-with(@src, '/blog_images/')]").each do |l|
      l[:src] =~ /\/blog_images\/([\d]+)\/([\d]+)\//
      id = (10000 * $1.to_i + $2.to_i)
      ids << id
    end
    BlogImage.update_all({:blog_id => self.id, :updated_at => self.updated_at}, {:id => ids})
  end

end
