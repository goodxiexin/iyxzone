module EmotionMacroHelpers

	def emotion_link text_area_id, opts = {}
		link_to_function image_tag('/images/icons/sweet.gif'), "emotion_converter.bind(this, '#{text_area_id}'); emotion_converter.show_faces(this);", opts
	end

end
