class MiniTopic < ActiveRecord::Base

  validates_uniqueness_of :name, :allow_blank => true
  
  validates_presence_of :name

  has_many :freq_nodes, :class_name => "MiniTopicFreqNode", :dependent => :destroy, :order => "created_at DESC"

  def freq_within from, to
    from_node, to_node = get_nodes_between(from, to)
    (to_node.nil? ? 0 : to_node[:freq]) - (from_node.nil? ? 0 : from_node[:freq])
  end

  def trend_within from, to
    from_node, to_node = get_nodes_between(from, to)
    (to_node.nil? ? 0 : to_node[:rank]) >= (from_node.nil? ? 0 : from_node[:rank]) 
  end

  def self.hot_within from, to
    MiniTopic.all.map{|t| [t.freq_within(from, to), t]}.sort{|a, b| b[0] <=> a[0]}.select{|a| a[0] != 0}
  end

  # this is expensive.. try to cache results
  def self.hot range=[]
    range = range.blank? ? [6.hours.ago, 1.day.ago, 2.day.ago, 7.day.ago] : range
    from = range.shift
    to = Time.now
    topics = []
    while true
      topics = MiniTopic.all.map{|t| [t.freq_within(from, to), t]}.sort{|a, b| b[0] <=> a[0]}.select{|a| a[0] != 0}
      if topics.blank?
        if range.empty?
          return [from, []]
        else
          from = range.shift
        end
      else
        break
      end
    end
    [from, topics]
  end

  # TODO
  # 按目前的高法，是美15分钟增加1个
  # 会导致这个比较大，而且排序的时候会比较慢
  # 排序慢可以cache结果
  # 太大则可能需要特别处理下，比如1天应该有24 * 4 = 96个node, 一周就该有96*7个
  # 但是其实只需要4个
  def add_node freq, rank, time
    freq_nodes.create(:freq => freq, :rank => rank, :created_at => time)
  end

protected
  
  def get_nodes_between from, to
    len = freq_nodes.size
    from_node = nil
    to_node = nil
    freq_nodes.each_with_index do |node, i|
      if to_node.nil? and freq_nodes[len - i - 1][:created_at] < to
        to_node = freq_nodes[len - i - 1]
      end
      if from_node.nil? and freq_nodes[len -i - 1][:created_at] < from
        from_node = freq_nodes[len -i - 1]
      end
    end
    [from_node, to_node]
  end

end
