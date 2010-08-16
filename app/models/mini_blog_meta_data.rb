class MiniBlogMetaData < ActiveRecord::Base

  serialize :random_ids, Array

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
