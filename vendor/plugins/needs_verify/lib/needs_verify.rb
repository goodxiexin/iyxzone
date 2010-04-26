# NeedsVerify
module NeedsVerify

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def needs_verification opts={}

      named_scope :unverified, :conditions => {:verified => 0}, :order => "created_at DESC"

      named_scope :accepted, :conditions => {:verified => 1}, :order => "created_at DESC"

      named_scope :rejected, :conditions => {:verified => 2}, :order => "created_at DESC"

      attr_protected :verified    

      include InstanceMethods

      extend SingletonMethods

    end

  end 

  module SingletonMethods

    def enable_verify_scope
      default_scope :conditions => {:verified => [0,1]}
    end

  end

  module InstanceMethods

    def verify
      self.verified = 1
      save  
    end

    def unverify
      self.verified = 2
      save
    end
  
  end

end

ActiveRecord::Base.send(:include, NeedsVerify)
