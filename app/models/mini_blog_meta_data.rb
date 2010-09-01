class MiniBlogMetaData < ActiveRecord::Base

  serialize :random_ids, Array

  # 用来cache每次计算排名的结果
  # cache的内容是
  # 6小时内的最热的50个话题，以[freq, term]形式保存
  # 24小时内的最热的50个话题，以[freq, term]形式保存
  # 2天的最热的50个话题，以[freq, term]形式保存
  # 1周内的的50个话题，以[freq, term]形式保存
  serialize :hot_topics, Array

  def today_hot_word
    HotWord.find_by_id(today_hot_word_id)
  end

  def find_hot_topics
    hot_topics.each_with_index do |topics, idx|
      if !topics.blank?
        return [idx, topics]
      end
    end
    return [nil, []]
  end

end
