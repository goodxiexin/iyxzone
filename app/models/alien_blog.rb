class AlienBlog < Blog	
	validate_presence_of :orig_link
	
protected
	def is_rss_link
		errors.add(:orig_link, "不能为空") if orig_link.blank?
		errors.add(:orig_link, "不是rss链接") if 
	end
end
