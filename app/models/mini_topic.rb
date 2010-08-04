class MiniTopic < ActiveRecord::Base

  validates_uniqueness_of :name, :allow_blank => true
  
  validates_presence_of :name

  serialize :nodes, Array

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

  def add_node freq, rank, time
    if nodes.blank?
      self.nodes = [{:freq => freq, :rank => rank, :created_at => time}]
    else
      self.nodes << {:freq => freq, :rank => rank, :created_at => time}
    end
    self.freq = freq
    self.save
  end

protected
  
  def get_nodes_between from, to
    len = nodes.size
    from_node = nil
    to_node = nil
    nodes.each_with_index do |node, i|
      if to_node.nil? and nodes[len - i - 1][:created_at] < to
        to_node = nodes[len - i - 1]
      end
      if from_node.nil? and nodes[len -i - 1][:created_at] < from
        from_node = nodes[len -i - 1]
      end
    end
    [from_node, to_node]
  end

end
