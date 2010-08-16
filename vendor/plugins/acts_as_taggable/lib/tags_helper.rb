module TagsHelper

	def tag_cloud(taggable, classes)
		return if taggable.nil?
		tag_infos = taggable.taggings.group_by(&:tag_id).sort{|a,b| b[1].count <=> a[1].count}[0..9]
		tag_ids = tag_infos.map {|tag_id, taggings| tag_id}
		tagging_counts = tag_infos.map {|tag_id, taggings| taggings.count}
		max_count = tagging_counts.max
    
    Tag.match(:id => tag_ids).all.each_with_index do |tag, i|
      index = ((tagging_counts[i] * (classes.size - 1)) / max_count).round
      yield tag, classes[index]
    end
  end

end
