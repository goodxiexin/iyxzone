class MiniBlogMetaData < ActiveRecord::Base

  serialize :random_ids, Array

  serialize :hot_topics, Array

  def find_hot_topics
    hot_topics.each_with_index do |topics, idx|
      if !topics.blank?
        return [idx, topics]
      end
    end
    return [nil, []]
  end

end
