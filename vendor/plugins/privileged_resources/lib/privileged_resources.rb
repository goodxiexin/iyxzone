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
    
    end

  end

	module SingletonMethods

		def viewable relationship, opts={}
      conditions = opts.delete(:conditions) || {}
			if conditions.is_a? Hash
				case relationship
				when 'owner'
				when 'friend'
					conditions.merge!({:privilege => [1,2,3]})
				when 'same_game'
					conditions.merge!({:privilege => [1,2]})
				when 'stranger'
					conditions.merge!({:privilege => 1})
				end
			elsif conditions.is_a? Array
				case relationship
				when 'owner'
				when 'friend'
					condtions[0] = "(" + conditions[0] + ")" + " AND privilege IN (1,2,3)"
				when 'same_game'
					condtions[0] = "(" + conditions[0] + ")" + " AND privilege IN (1,2)"
				when 'stranger'
					condtions[0] = "(" + conditions[0] + ")" + " AND privilege IN (1)"
				end
			elsif conditions.is_a? String
        case relationship
        when 'owner'
        when 'friend'
          condtions = "(" + conditions + ")" + " AND privilege IN (1,2,3)"
        when 'same_game'
          condtions = "(" + conditions + ")" + " AND privilege IN (1,2)"
        when 'stranger'
          condtions = "(" + conditions + ")" + " AND privilege IN (1)"
				end
			end
			opts.merge!({:conditions => conditions})
			find(:all, opts)
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

      def is_public_privilege?
        privilege == 1
      end        
        
      def is_friend_privilege?
        privilege == 3
      end

      def is_friend_or_same_game_privilege?
        privilege == 2
      end

      def available_for? user
        (resource_owner == user) || 
        (is_public_privilege?) || 
        (is_friend_privilege? and (resource_owner.has_friend? user or resource_owner.wait_for? user)) || 
        (is_friend_or_same_game_privilege? and (resource_owner.has_friend? user or resource_owner.has_same_game_with? user)) || false        
      end

  end

end

end

ActiveRecord::Base.send(:include, PrivilegedResource::Model)
