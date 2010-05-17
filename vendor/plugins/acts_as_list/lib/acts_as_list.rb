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

    def merge_sql sql_array, sql
      if !sql.blank?
        sql_array.insert(0, "(#{sql_array.shift}) AND (#{sql})")
      else
        sql_array
      end 
    end

    def next my_cond={}
      order_name = self.class.list_opts[:order]
      order = send(order_name)
      list_sql = list_cond
      my_cond_sql = self.class.send(:sanitize_sql_for_conditions, my_cond)
      next_sql = merge_sql ["#{order_name} > ?", order], list_sql
      next_sql = merge_sql next_sql, my_cond_sql
      
      next_in_list = self.class.first(:conditions => next_sql, :order => "#{order_name} ASC")

      if next_in_list.nil? and self.class.list_opts[:circular]
        next_in_list = self.class.first(:conditions => [list_sql, my_cond_sql].reject{|sql| sql.blank?}.join(' AND '), :order => "#{order_name} ASC")
      end

      next_in_list
		end
    
    def prev my_cond={}
      order_name = self.class.list_opts[:order]
      order = send(order_name)
      list_sql = list_cond
      my_cond_sql = self.class.send(:sanitize_sql_for_conditions, my_cond)
      prev_sql = merge_sql ["#{order_name} < ?", order], list_sql
      prev_sql = merge_sql prev_sql, my_cond_sql
      
      prev_in_list = self.class.first(:conditions => prev_sql, :order => "#{order_name} DESC")

      if prev_in_list.nil? and self.class.list_opts[:circular]
        prev_in_list = self.class.first(:conditions => "#{list_sql} AND #{my_cond_sql}", :order => "#{order_name} DESC")
      end

      prev_in_list
		end

  protected

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

	end

end

ActiveRecord::Base.send(:include, ActsAsList)
