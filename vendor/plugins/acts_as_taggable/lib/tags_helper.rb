module TagsHelper

	def tag_cloud(taggable, classes)
		return if taggable.nil?
		tag_infos = taggable.taggings.group_by(&:tag_id).sort{rand}[0..14]
		tag_ids = tag_infos.map {|tag_id, taggings| tag_id}
		tagging_counts = tag_infos.map {|tag_id, taggings| taggings.count}
		max_count = tagging_counts.max
    
    Tag.match(:id => tag_ids).all.each_with_index do |tag, i|
      index = ((tagging_counts[i] / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end

end
