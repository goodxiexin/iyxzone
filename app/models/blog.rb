class Blog < ActiveRecord::Base

  related_to_game 

	belongs_to :poster, :class_name => 'User'

  has_many :images, :class_name => 'BlogImage', :dependent => :delete_all

  named_scope :by, lambda {|user_ids| {:conditions => {:poster_id => user_ids, :draft => false}}}

  named_scope :hot, :conditions => ["draft = 0 AND created_at > ?", 2.weeks.ago.to_s(:db)], :order => "digs_count DESC, created_at DESC"

  named_scope :recent, :conditions => ["draft = 0 AND created_at > ?", 2.weeks.ago.to_s(:db)], :order => "created_at DESC"
  
  needs_verification :sensitive_columns => [:content, :title]

  acts_as_random
  
  acts_as_friend_taggable 

  acts_as_viewable

	acts_as_diggable :create_conditions => lambda {|user, blog|
    !blog.draft and blog.available_for?(user.relationship_with(blog.poster))
  }

  acts_as_resource_feeds :recipients => lambda {|blog| 
    poster = blog.poster
    friends = poster.friends.all(:select => "users.id, users.application_setting").find_all {|f| f.application_setting.recv_blog_feed?}
    fans = poster.is_idol ? poster.fans.all(:select => "users.id") : []
    (poster.all_guilds + friends + fans).uniq
  }
  
  acts_as_list :order => 'created_at', :scope => 'poster_id', :conditions => {:draft => false}

  acts_as_privileged_resources :owner_field => :poster

  acts_as_commentable :order => 'created_at ASC', 
                      :delete_conditions => lambda {|user, blog, comment| user == blog.poster || user == comment.poster}, 
                      :create_conditions => lambda {|user, blog| !blog.draft and blog.available_for?(user.relationship_with(blog.poster))}

  acts_as_abstract :columns => [:content]

  attr_readonly :poster_id

  validates_size_of :title, :within => 1..100

  validates_presence_of :poster_id, :on => :create

  validates_size_of :content, :within => 1..10000

  after_save :update_blog_images

protected

  def update_blog_images
    ids = BlogImage.parse_images self
    BlogImage.update_all({:blog_id => nil}, {:id => (images.map(&:id) - ids)})
    BlogImage.update_all({:blog_id => self.id}, {:id => ids})
  end

end
