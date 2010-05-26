class Ku6

	KU6_SINGLE	= /http:\/\/v\.ku6\.com\/show\/(.*)\.htm[l]/
	
  KU6_ALBUM		=	/http:\/\/v\.ku6\.com\/(special|film)\/show_[\d]*\/(.*)\.htm[l]/

  KU6_HD			= /http:\/\/hd\.ku6\.com\/show\/[\w]*\.htm[l]/

	include HTTParty

	def self.identify_url(video_url)
		if KU6_SINGLE.match(video_url)
			return true
		elsif KU6_ALBUM.match(video_url)
			return true
		elsif KU6_HD.match(video_url)
			return false
		end
	end
		
	def initialize(obj)
    @embed_url = 
		  if KU6_SINGLE.match obj.video_url
        "http://player.ku6.com/refer/#{$1}/v.swf"
      elsif KU6_ALBUM.match obj.video_url
        "http://player.ku6.com/refer/#{$2}/v.swf"
      end
	end

	def thumbnail_url
		"/images/videoThumb/ku6.png"
	end

	def embed_html
		"<embed src=\"#{@embed_url}\" quality=\"high\" width=\"470\" height=\"392\" align=\"middle\" allowScriptAccess=\"always\" allowfullscreen=\"true\" type=\"application/x-shockwave-flash\"></embed>"
	end

end
