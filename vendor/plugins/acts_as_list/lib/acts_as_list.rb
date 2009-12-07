module ActsAsList

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
	
		def acts_as_list opts

			cattr_accessor :list_opts
	
			self.list_opts = opts

			extend ActsAsList::SingletonMethods

			include ActsAsList::InstanceMethods

		end

	end

	module SingletonMethods
	end

	module InstanceMethods

		def scope_name
			self.class.list_opts[:scope]
		end

		def order_name
			self.class.list_opts[:order]
		end
		
		def scope
			send(scope_name)
		end

		def order
			send(order_name)
		end

		def first
			self.class.find(:first, :conditions => ["#{scope_name} = ?", scope], :order => "#{order_name} ASC")
		end

		def last
			self.class.find(:first, :conditions => ["#{scope_name} = ?", scope], :order => "#{order_name} DESC")
		end

		def next
			self.class.find(:first, :conditions => ["#{scope_name} = ? AND #{order_name} > ?", scope, order], :order => "#{order_name} ASC") || first 
		end

		def prev
			self.class.find(:first, :conditions => ["#{scope_name} = ? AND #{order_name} < ?", scope, order], :order => "#{order_name} DESC") || last 
		end
	
	end

end

ActiveRecord::Base.send(:include, ActsAsList)
