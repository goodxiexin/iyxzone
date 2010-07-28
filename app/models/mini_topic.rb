class MiniTopic < ActiveRecord::Base

  validates_presence_of :name

  named_scope :hot, :order => "freq DESC"

  named_scope :within, lambda {|from, to| {:conditions => ["created_at > ? AND created_at < ?", from, to]}}

  has_many :nodes, :class_name => "MiniTopicNode", :order => "created_at DESC", :dependent => :destroy

  def ascend?
    last_topic = MiniTopic.find(:first, :conditions => {:name => self.name}, :order => "created_at DESC")
    if last_topic
      (freq - last_topic.freq) > 0
    else
      true
    end
  end

  def freq_within from, to
    from_topic = MiniTopic.find :first, :conditions => ["name = ? AND created_at < ?", name, from.to_s(:db)], :order => "created_at DESC"
    to_topic = MiniTopic.find :first, :conditions => ["name = ? AND created_at > ?", name, to.to_s(:db)], :order => "created_at ASC"
    from_freq = from_topic.blank? ? 0 : from_topic.freq
    to_freq = to_topic.blank? ? 0 : to_topic.freq
    to_freq - from_freq
  end

  # TIP
  # 这个函数不该被常常调用，因为很耗时间，应该在调用该函数后想个办法cache结果

end
