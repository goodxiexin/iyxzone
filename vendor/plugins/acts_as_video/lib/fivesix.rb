class FiveSix
	
	FIVESIX_SINGLE  = /http:\/\/(www\.)?56\.com\/u[\d]*\/v_([\w]*)\.htm[l]/
	
  FIVESIX_ALBUM		= /http:\/\/(www\.)?56\.com\/w[\d]*\/play_album-aid-[\d]*_vid-([\w])*\.htm[l]/
	
  FIVESIX_PHOTO 	= /http:\/\/(www\.)?56\.com\/p[\d]*\/v_[\w]*\.htm[l]/

	include HTTParty

	format :json

	base_uri 'www.56.com'

	def self.identify_url(videourl)
		if FIVESIX_SINGLE.match(videourl)
			return true
		elsif FIVESIX_ALBUM.match(videourl) 
			return true 
		elsif FIVESIX_PHOTO.match(videourl)
			return false
		end
	end

	
	def initialize video_url
		@embed_url = 
		  if FIVESIX_SINGLE.match video_url
        "http://player.56.com/v_#{$1}.swf"
		  elsif FIVESIX_ALBUM.match video_url
        "http://player.56.com/v_#{$1}.swf"
		  end
	end

	def thumbnail_url
			"/images/videoThumb/56.png"
	end

	def embed_html
		'<embed src="' +  @embed_url +  '" type="application/x-shockwave-flash" width="470" height="390"></embed>'
	end

end
