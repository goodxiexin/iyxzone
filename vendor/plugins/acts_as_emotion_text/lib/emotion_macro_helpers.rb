module EmotionMacroHelpers

	def emotion_link text_area_id, opts = {}
    link_to_function '', "Iyxzone.Emotion.Manager.toggleFaces(this, $('#{text_area_id}'), event)", opts
	end

  def emotion_text text
    Emotion.parse text
  end

end
