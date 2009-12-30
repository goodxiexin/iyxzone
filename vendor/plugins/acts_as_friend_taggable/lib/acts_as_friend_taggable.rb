module FriendTaggable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_friend_taggable opts={}
      has_many :tags, :class_name => opts[:class_name], :as => 'taggable', :dependent => :destroy

			cattr_accessor :friend_taggable_opts

			self.friend_taggable_opts = opts

      include FriendTaggable::InstanceMethods

      extend FriendTaggable::SingletonMethods
    end

  end

  module SingletonMethods

		def relative_to user_id, game_id=nil
			conditions = friend_taggable_opts[:conditions] || {}
			conditions.merge!({:game_id => game_id}) unless game_id.nil?
			find(:all, :joins => "INNER JOIN friend_tags ON friend_tags.taggable_id = #{self.name.underscore.pluralize}.id AND friend_tags.taggable_type = '#{self.name}' AND friend_tags.friend_id = #{user_id}", :conditions => conditions, :order => 'created_at DESC')
		end	

  end

  module InstanceMethods

		def relative_users
			tags.map {|tag| tag.friend}
		end

  end

end

ActiveRecord::Base.send(:include, FriendTaggable)

