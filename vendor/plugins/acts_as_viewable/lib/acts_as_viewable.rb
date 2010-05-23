module Viewable

module Model

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_viewable opts={}

      has_many :viewings, :as => 'viewable', :order => 'viewed_at DESC', :dependent => :delete_all

      has_many :viewers, :through => :viewings, :source => 'user'

      cattr_accessor :viewable_opts

      self.viewable_opts = opts

      include Viewable::Model::InstanceMethods

      extend Viewable::Model::SingletonMethods
    end   

  end

  module SingletonMethods

  end

  module InstanceMethods

		def viewed_by? user
			!viewings.find_by_user_id(user.id).nil?
		end

    def is_viewable_by? user
      proc = self.viewable_opts[:create_conditions] || lambda { true }
      proc.call self, user
    end

    def viewed_by user
      viewing = viewings.first(:conditions => {:user_id => user.id})
      if viewing.blank?
        viewings.create(:user_id => user.id) if is_viewable_by?(user)
      else
        viewing.update_attribute(:viewed_at, Time.now) 
      end
    end

  end

end

module Controller

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      include Viewable::Controller::InstanceMethods
    end
  end
 
  module ClassMethods

    def increment_viewing variable_name, opts
      cattr_accessor :viewing_opts
      self.viewing_opts = {:variable_name => variable_name, :filter_opts => opts}
      after_filter :create_or_update_viewing, opts
    end

  end
 
  module InstanceMethods
   
    def create_or_update_viewing
      opts = self.class.viewing_opts
      viewable = eval("@#{opts[:variable_name]}")
      viewable.viewed_by current_user
    end
 
  end
  

end

end

ActiveRecord::Base.send(:include, Viewable::Model)
