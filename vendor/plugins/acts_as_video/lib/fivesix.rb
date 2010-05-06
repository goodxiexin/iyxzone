class FiveSix
	
	# http://www.56.com/u61/v_NDk2OTc4NzQ.html
	# <embed src="http://player.56.com/v_NDk2OTc4NzQ.swf"  type="application/x-shockwave-flash" width="480" height="395"></embed>
	FIVESIX_SINGLE  = /http:\/\/(www\.)?56\.com\/u[\d]*\/v_[\w]*\.htm[l]/
	# http://www.56.com/w88/play_album-aid-7928642_vid-NDk1MzA4NTg.html
	#	<embed src="http://www.56.com/cpm_NDk1MzA4NTg.swf"  type="application/x-shockwave-flash" width="480" height="395"></embed> 
	FIVESIX_ALBUM		= /http:\/\/(www\.)?56\.com\/w[\d]*\/play_album-aid-[\d]*_vid-[\w]*\.htm[l]/
	# http://www.56.com/p80/v_NzQxMTA2Nzc.html
	# <embed src="http://www.56.com/deux13_74110677.swf"  type="application/x-shockwave-flash" width="460" height="385"></embed>
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

	
	def initialize(obj)
		@video_id = 
		if FIVESIX_SINGLE.match(obj.video_url)
			obj.video_url.split('/v_').last.split('.html').first
		elsif FIVESIX_ALBUM.match(obj.video_url)
			obj.video_url.split('_vid-').last.split('.html').first
		end
		@embed_url = 
		if @video_id 
			"http://player.56.com/v_" + @video_id + '.swf'
		end
	end

	def thumbnail_url
			"/images/videoThumb/56.png"
	end

	def embed_html
		'<embed src="' +  @embed_url +  '" type="application/x-shockwave-flash" width="470" height="390"></embed>'
	end

end
