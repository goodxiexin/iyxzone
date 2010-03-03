# ActsAsShareable
module Shareable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_shareable opts={}
      has_many :sharings, :as => 'shareable', :dependent => :destroy, :order => opts[:order]

      include Shareable::InstanceMethods

      extend Shareable::SingletonMethods

      cattr_accessor :share_opts

      self.share_opts = opts

    end

  end

  module SingletonMethods
  end

  module InstanceMethods

    def shared_by? user
      !sharings.find_by_poster_id(user.id).nil?
    end

    def first_sharer
      sharings.find(:first, :order => "created_at ASC").poster
    end

    def default_share_title
      @default_share_title unless @default_share_title.blank?

      proc = self.class.share_opts[:default_title] || lambda { '' }
      @default_share_title = proc.call self 
    end

  end

end

ActiveRecord::Base.send(:include, Shareable)
