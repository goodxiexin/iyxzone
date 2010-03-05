# NeedsVerify
module NeedsVerify

module Model

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def needs_verification opts={}

      named_scope :unverified, :conditions => {:verified => 0}, :order => "created_at DESC"

      named_scope :accepted, :conditions => {:verified => 1}, :order => "created_at DESC"

      named_scope :rejected, :conditions => {:verified => 2}, :order => "created_at DESC"

      attr_protected :verified    

      include Commentable::InstanceMethods

      extend Commentable::SingletonMethods

    end

  end 

  module SingletonMethods
  end

  module InstanceMethods

    def verify
      verified = 1
      save  
    end

    def unverify
      verified = 2
      save
    end
  
  end

end

module Controller

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def require_verified model_name, opts={}
      before_filter opts do |controller| 
        model_name.camelize.constantize.class_eval do
          default_scope :conditions => {:verified => [0,1]}
        end
      end
    end

  end

end

end

ActiveRecord::Base.send(:include, NeedsVerify::Model)
ActionController::Base.send(:include, NeedsVerify::Controller)
