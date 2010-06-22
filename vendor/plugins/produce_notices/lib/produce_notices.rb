# ProduceNotices
module ProduceNotices

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def produce_notices opts={}

      has_many :notices, :as => 'producer', :dependent => :destroy

      include ProduceNotices::InstanceMethods

      extend ProduceNotices::SingletonMethods
    
      cattr_accessor :notice_opts

      self.notice_opts = opts
    end   

  end

  module SingletonMethods
  end

  module InstanceMethods
  end

end

ActiveRecord::Base.send(:include, ProduceNotices)

