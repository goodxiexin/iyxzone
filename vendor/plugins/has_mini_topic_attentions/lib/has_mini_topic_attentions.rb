# HasMiniTopicAttentions
module HasMiniTopicAttentions

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def has_mini_topic_attentions opts={}
      
      include HasMiniTopicAttentions::InstanceMethods

      extend HasMiniTopicAttentions::SingletonMethods

      cattr_accessor :mta_opts

      self.mta_opts = opts

      define_method("topic_name") do
        eval("self.#{opts[:column]}")
      end

    end

  end

  module SingletonMethods
  end

  module InstanceMethods
  
    def followed_by? user
      user.mini_topic_attentions.find_by_topic_name(self.topic_name)
    end

    def follow_by user
      a = user.mini_topic_attentions.build :topic_name => self.topic_name
      a.save
    end

    def unfollow_by user
      a = user.mini_topic_attentions.find_by_topic_name(self.topic_name)
      if a
        a.destroy
      else
        false
      end
    end

  end

end

ActiveRecord::Base.send(:include, HasMiniTopicAttentions)
