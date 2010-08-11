# ActsAsRandom
module ActsAsRandom

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def acts_as_random opts={}

      include ActsAsRandom::InstanceMethods

      extend ActsAsRandom::SingletonMethods    

    end

  end

  module SingletonMethods
    
    # 这里有个假设，就是该表的id域是unique的
    # 另外，如果是join, 再random那会很慢，因为数据库没有索引
    def random opts={}
      cond = opts[:conditions] || {}
      prefetch = opts[:include] || []
      count = self.count("id", :conditions => cond, :distinct => true)
      except = opts[:except] || []
      limit = opts[:limit] || 1
      select = opts[:select] || "*"
      picked = []
      if limit + except.uniq.count >= count
        # just return all records
        picked = self.all(:conditions => cond, :include => prefetch, :select => select) - except
      else
        limit.times.each do
          while 1
            record = self.find(:first, :conditions => cond, :select => select, :include => prefetch, :offset => rand(count))
            if !picked.include?(record) and !except.include?(record)
              picked << record
              break
            end
          end
        end
        picked
      end
    end

  end

  module InstanceMethods
  end 

end

ActiveRecord::Base.send(:include, ActsAsRandom)
