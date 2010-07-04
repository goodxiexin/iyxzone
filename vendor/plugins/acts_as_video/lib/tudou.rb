class Tudou

	TUDOU_SINGLE 	= /http:\/\/www\.tudou\.com\/programs\/view\/([\w]*)\/?/

	TUDOU_ALBUM 	= /http:\/\/www\.tudou\.com\/playlist\/playindex\.do\?lid=[\d]*&iid=([\d]*)&cid=[\d]*/
  
  TUDOU_ALBUM2  = /http:\/\/www\.tudou\.com\/playlist\/playindex\.do\?lid=([\d]*)/

  TUDOU_HD			= /http:\/\/hd\.tudou\.com\/program\/[\d]*\//

	include HTTParty

	format :json

	base_uri ''
	
	def self.identify_url(video_url)
		if TUDOU_SINGLE.match(video_url)
			return true
		elsif TUDOU_ALBUM.match(video_url)
			return true
    elsif TUDOU_ALBUM2.match(video_url)
      return true
		elsif TUDOU_HD.match(video_url)
			return false 
		end
	end

	def initialize video_url
    @embed_url = 
		  if TUDOU_SINGLE.match video_url
        "http://www.tudou.com/v/#{$1}"
		  elsif TUDOU_ALBUM.match video_url 
        "http://www.tudou.com/player/skin/plu.swf?iid=#{$1}"
      elsif TUDOU_ALBUM2.match video_url
        "http://www.tudou.com/l/#{$1}"
      end
	end

	def thumbnail_url
		"/images/videoThumb/tudou.png"
	end

	def embed_html
    '<embed height="400" align="middle" width="480" src="' + @embed_url + '" type="application/x-shockwave-flash" allowscriptaccess="always"/>'
	  #'<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="450" height="363" align="middle"><param name="movie" value="' + @embed_url + '"></param><param name="allowScriptAccess" value="always"></param><param name="allowFullScreen" value="true"></param><param name="quality" value="high"></param><param name="wmode" value="transparent"></param><embed src="' +@video_id + '" quality="high" width="450" height="363" align="middle" allowScriptAccess="always" allowFullScreen="true" wmode="transparent" type="application/x-shockwave-flash"></embed></object>'
	end	

end
