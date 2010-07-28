class MiniTopicNode < ActiveRecord::Base

  belongs_to :mini_topic

  def next
  end

  def prev
  end

end
