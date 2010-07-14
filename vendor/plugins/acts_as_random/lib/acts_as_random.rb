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
    
    def random opts={}
      cond = opts[:conditions] || {}
      prefetch = opts[:include] || []
      count = self.count( :conditions => cond)
      except = opts[:except] || []
      limit = opts[:limit] || 1
      picked = []
      if limit + except.uniq.count >= count
        # just return all records
        picked = self.all(:conditions => cond, :include => prefetch) - except
      else
        limit.times.each do
          while 1
            record = self.find(:first, :conditions => cond, :include => prefetch, :offset => rand(count))
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
