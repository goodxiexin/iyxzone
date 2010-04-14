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

    def is_viewing_createable_by? user
      proc = self.class.viewable_opts[:create_conditions] || lambda { true }
      proc.call user, self
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

    def increment_viewing(model_name, through, opts)
      cattr_accessor :viewing_opts
      self.viewing_opts = {:model_name => model_name, :through => through, :filter_opts => opts}
      after_filter :create_or_update_viewing, opts
    end

  end
 
  module InstanceMethods
   
    def create_or_update_viewing
      opts = self.class.viewing_opts
      model_name = opts[:model_name]
      klass = model_name.camelize.constantize
      through = opts[:through]
      viewable = klass.find(params["#{through}"])
      viewing = viewable.viewings.find(:first, :conditions => {:user_id => current_user.id})
      if viewing.nil?
        viewable.viewings.create(:user_id => current_user.id)
      else
        viewing.update_attribute('viewed_at', Time.now.to_s(:db))
      end
    end
 
  end
  

end

end

ActiveRecord::Base.send(:include, Viewable::Model)

ActionController::Base.send(:include, Viewable::Controller)
