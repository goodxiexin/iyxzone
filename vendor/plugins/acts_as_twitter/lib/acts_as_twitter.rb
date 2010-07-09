module ActsAsTwitter

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_twitter opts={}

      has_many :mini_blogs, :conditions => {:deleted => false}, :dependent => :destroy, :as => 'poster', :order => 'created_at DESC'

      include ActsAsTwitter::InstanceMethods

      extend ActsAsTwitter::SingletonMethods
    
      cattr_accessor :twitter_opts
    end   

  end

  module SingletonMethods
  end

  module InstanceMethods
  
    def is_mini_blog_createable_by? user
      proc = self.class.twitter_opts[:create_conditions] || lambda { true }
      proc.call user, self
    end

    def is_mini_blog_deleteable_by? user, mini_blog
      proc = self.class.twitter_opts[:delete_conditions] || lambda { false }
      proc.call user, mini_blog
    end

  end

end

ActiveRecord::Base.send(:include, Commentable)

