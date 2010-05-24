module OrdAttr
	def self.included(base)
		base.send :extend, ClassMethods
	end

	module ClassMethods
		def acts_as_ord_attr(*arr)
			send :include, InstanceMethods
			#define these syms to accessor
			arr.each do |sym|

			end
		end
	end

	module InstanceMethods

	end

end

ActiveRecord::Base.send	:include, OrdAttr
