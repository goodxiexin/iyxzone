# 提供机制而不是策略
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

  def add_node freq, rank, time
		last_node = freq_nodes.last
		if last_node.blank? or freq != last_node.freq
			freq_nodes.create(:freq => freq, :rank => rank, :created_at => time)
		end
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
