module Commentable

  def self.included(base)
    base.extend(ClassMethods)
  end

	module ClassMethods

		def acts_as_commentable opts={}
			has_many :comments, :as => 'commentable', :dependent => :destroy, :order => opts[:order]

			include Commentable::InstanceMethods

			extend Commentable::SingletonMethods
		end		

	end

	module SingletonMethods
	end

	module InstanceMethods
	end

end

ActiveRecord::Base.send(:include, Commentable)
