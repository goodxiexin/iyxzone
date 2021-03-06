module FriendTaggable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_friend_taggable opts={}
      
      has_many :tags, :class_name => 'FriendTag', :as => 'taggable', :dependent => :destroy

      has_many :relative_users, :through => :tags, :source => :tagged_user

			cattr_accessor :friend_taggable_opts

			self.friend_taggable_opts = opts

      after_save :save_friend_tags

      include FriendTaggable::InstanceMethods

      extend FriendTaggable::SingletonMethods

    end

  end

  module SingletonMethods

  end

  module InstanceMethods

    def new_friend_tags= ids
      @new_tagged_user_ids = ids  
    end

    def del_friend_tags= ids
      @del_tagged_user_ids = ids
    end

    def new_friend_tags
      @new_tagged_user_ids
    end

    def del_friend_tags
      @del_tagged_user_ids
    end 

    def has_tag? user
      user_id = (user.is_a? Integer)? user : user.id
      tags.find_by_tagged_user_id(user_id)
    end
  
  protected

    def save_friend_tags
      unless @del_tagged_user_ids.blank?
        @del_tagged_user_ids.each { |id| tags.match(:tagged_user_id => id).first.destroy }
        @del_tagged_user_ids = nil
      end

      unless @new_tagged_user_ids.blank?
        @new_tagged_user_ids.each { |id| tags.create(:tagged_user_id => id, :poster_id => poster_id) } 
        @new_tagged_user_ids = nil
      end
    end
  
  end

end

ActiveRecord::Base.send(:include, FriendTaggable)

