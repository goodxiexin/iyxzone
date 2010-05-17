# ActsAsAbstract
require 'sanitize'

module ActsAsAbstract

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def acts_as_abstract opts={}

      cattr_accessor :abstract_opts

      self.abstract_opts = opts

      before_save :save_abstract

      include ActsAsAbstract::InstanceMethods

      extend ActsAsAbstract::SingletonMethods 

    end

  end

  module InstanceMethods

    def save_abstract
      opts = self.class.abstract_opts
      if_cond = opts[:if] || "true" 
      opts[:columns].each do |column|
        changed = eval("self.#{column}_changed?")
        if changed and eval(if_cond)
          eval("self.#{column}_abstract = Sanitize.clean(self.#{column})")
        end
      end 
    end

  end
  
  module SingletonMethods

  end

end

ActiveRecord::Base.send(:include, ActsAsAbstract)
