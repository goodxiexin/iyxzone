class Youku
	
	YOUKU_SINGLE	= /http:\/\/v\.youku\.com\/v_show\/id_([\w]*)\=?\.htm[l]?/
	
  YOUKU_ALBUM		= /http:\/\/v\.youku\.com\/v_playlist\/f(.*)o([0-9]+)p([0-9]+)\.htm[l]?/

	include HTTParty

	format :json

	base_uri 'v.youku.com/player/getPlayList'

	def self.identify_url video_url
		if YOUKU_SINGLE.match(video_url)
			return true
		elsif YOUKU_ALBUM.match(video_url)
      return true
    end
	end

	
	def initialize video_url
    if YOUKU_SINGLE.match video_url
      @embed_url = "http://player.youku.com/player.php/sid/#{$1}/v.swf"
      @response  = self.class.get("/VideoIDS/#{$1}")
    elsif YOUKU_ALBUM.match video_url
      @embed_url = "http://www.youku.com/player.php/Type/Folder/Fid/#{$1}/Ob/#{$2}/Pt/#{$3}"
    end
	end

	def thumbnail_url
		unless @response.nil?
      @response["data"][0]["logo"] 
		else
			"/images/videoThumb/youku.png"
		end
	end

	def embed_html
		"<embed src=\""+ @embed_url + "\" quality=\"high\" width=\"470\" height=\"392\" align=\"middle\" allowScriptAccess=\"sameDomain\" type=\"application/x-shockwave-flash\" wmode=\"transparent\"></embed>"
	end

end
