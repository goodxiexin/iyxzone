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

      define_method "save_abstract" do
        opts = self.class.abstract_opts
        opts[:columns].each do |column|
          changed = eval("self.#{column}_changed?")
					if changed
            eval("self.#{column}_abstract = Sanitize.clean(self.#{column})")
					end
        end 
      end

    end
  
  end 

end

ActiveRecord::Base.send(:include, ActsAsAbstract)
