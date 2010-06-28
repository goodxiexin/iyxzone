class MiniBlogTopic < ActiveRecord::Base

  belongs_to :mini_blog

  belongs_to :mini_topic

end
