module ActsAsAttentionable

  def self.included base
    base.extend(ClassMethods)
  end

  module ClassMethods
  
    def acts_as_attentionable opts={}

      has_many :attentions, :dependent => :destroy, :as => 'attentionable', :order => 'created_at DESC'

      has_many :followers, :through => :attentions, :source => :follower

      cattr_accessor :attention_opts

      self.attention_opts = opts

      include ActsAsAttentionable::InstanceMethods

      extend ActsAsAttentionable::SingletonMethods 

    end

  end

  module InstanceMethods

    def followed_by user
      attention = attentions.build :follower_id => user.id
      attention.save
    end

    def followed_by? user
      !attentions.find_by_follower_id(user.id).blank?
    end

    def unfollowed_by user
      attention = attentions.find_by_follower_id(user.id)
      if attention.nil?
        false
      else
        attention.destroy
      end
    end

  end
  
  module SingletonMethods

  end

end

ActiveRecord::Base.send(:include, ActsAsAttentionable)

