module ActsAsList

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
	
		def acts_as_list opts

			cattr_accessor :list_opts
	
			self.list_opts = {:circular => true}.merge(opts)

			extend ActsAsList::SingletonMethods

			include ActsAsList::InstanceMethods

		end

	end

	module SingletonMethods
	end

	module InstanceMethods

    def list_cond
      opts = self.class.list_opts
      scope = opts[:scope]
      cond = opts[:conditions]
      
      if scope
        scope_value = send(scope)
        if cond
          "(#{scope} = #{scope_value}) AND (#{self.class.send(:sanitize_sql_for_conditions, cond)})"
        else
          "(#{scope} = #{scope_value})"
        end
      else
        if cond
          "(#{self.class.send(:sanitize_sql_for_conditions, cond)})"
        else
          ""
        end
      end
    end

		def first
      if @first_in_list
        return @first_in_list
      end

      order_name = self.class.list_opts[:order]
 
      @first_in_list ||= self.class.first(:conditions => list_cond, :order => "#{order_name} ASC")
    end

		def last
      if @last_in_list
        return @last_in_list
      end

      order_name = self.class.list_opts[:order]
 
			@last_in_list ||= self.class.find(:first, :conditions => list_cond, :order => "#{order_name} DESC")
		end

		def next
      if @next_in_list
        return @next_in_list
      end

      order_name = self.class.list_opts[:order]
      order = send(order_name)

      cond_sql = list_cond
      if cond_sql.blank?
        cond_sql = ["#{order_name} > ?", order]
      else
        cond_sql = ["(#{cond_sql}) AND #{order_name} > ?", order]
      end
      
      @next_in_list = self.class.first(:conditions => cond_sql, :order => "#{order_name} ASC")
      
      if @next_in_list.blank? and self.class.list_opts[:circular]
        @next_in_list = first
      end

      @next_in_list
		end

		def prev
      if @prev_in_list
        return @prev_in_list
      end

      order_name = self.class.list_opts[:order]
      order = send(order_name)

      cond_sql = list_cond
      if cond_sql.blank?
        cond_sql = ["#{order_name} < ?", order]
      else
        cond_sql = ["(#{cond_sql}) AND #{order_name} < ?", order]
      end

      @prev_in_list = self.class.first(:conditions => cond_sql, :order => "#{order_name} DESC")
      
      if @prev_in_list.blank? and self.class.list_opts[:circular]
        @prev_in_list = last
      end

      @prev_in_list
		end
	
	end

end

ActiveRecord::Base.send(:include, ActsAsList)
