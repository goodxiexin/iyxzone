class MiniTopicAttention < ActiveRecord::Base

  belongs_to :user

  validates_size_of :topic_name, :within => 1..20

  validates_uniqueness_of :topic_name, :scope => [:user_id]

end
