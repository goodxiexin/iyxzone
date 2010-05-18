# PrivilegedResource
module PrivilegedResource

module Model

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_privileged_resources opts={}

      cattr_accessor :privilege_opts

      self.privilege_opts = opts

      include InstanceMethods

      extend SingletonMethods

      named_scope :for, lambda {|relationship| {:conditions => privilege_cond(relationship)}}

      validates_inclusion_of :privilege, :in => [1, 2, 3, 4], :message => "只能是1,2,3,4中的一个"  
    
    end

  end

	module SingletonMethods

    def privilege_cond relationship
      if relationship == 'owner'
        {:privilege => [1,2,3,4]}
      elsif relationship == 'friend'
        {:privilege => [1,2,3]}
      elsif relationship == 'same_game'
        {:privilege => [1,2]}
      else
        {:privilege => 1}
      end
    end

	end
  
	module InstanceMethods
		
      def resource_owner
        @resource_owner unless @resource_owner.nil?

        owner_field = self.class.privilege_opts[:owner_field]
        @resource_owner = eval("self.#{owner_field}")
      end

      def is_owner_privilege?
        privilege == 4
      end

      def was_owner_privilege?
        privilege_was == 4
      end

      def available_for? relationship
        relationship == 'owner' || privilege == 1 || relationship == 'friend' || (privilege == 3 and relationship == 'same_game')
      end

  end

end

end

ActiveRecord::Base.send(:include, PrivilegedResource::Model)
