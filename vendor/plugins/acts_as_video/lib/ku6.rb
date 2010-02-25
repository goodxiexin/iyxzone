class Ku6

	# http://v.ku6.com/show/WZM-9HN3rTfu_qzS.html
	KU6_SINGLE	= /http:\/\/v\.ku6\.com\/show\/[\w]*\.html/
	# http://v.ku6.com/special/show_3743641/iEz6t9G4drXhYVl_.html
	# <embed src="http://player.ku6.com/refer/iEz6t9G4drXhYVl_/v.swf" quality="high" width="480" height="400" align="middle" allowScriptAccess="always" allowfullscreen="true" type="application/x-shockwave-flash"></embed>
	KU6_ALBUM		=	/http:\/\/v\.ku6\.com\/special\/show_[\d]*\/[\w]*\.html/
	# http://hd.ku6.com/show/6QZCPddfBQOue1xL.html
	# <embed src="http://player.ku6.com/refer/tGwGU3N2KITR36lN/v.swf" quality="high" width="414" height="305" align="middle" allowScriptAccess="always" allowfullscreen="true" type="application/x-shockwave-flash"></embed>

	# http://hd.ku6.com/show/6QZCPddfBQOue1xL.html
	# <embed src="http://player.ku6.com/refer/tGwGU3N2KITR36lN/v.swf" quality="high" width="414" height="305" align="middle" allowScriptAccess="always" allowfullscreen="true" type="application/x-shockwave-flash"></embed>
	KU6_HD			= /http:\/\/hd\.ku6\.com\/show\/[\w]*\.html/

	include HTTParty

	def self.identify_url(video_url)
		if KU6_SINGLE.match(video_url)
			return true
		elsif KU6_ALBUM.match(video_url)
			return true
		elsif KU6_HD.match(video_url)
#TODO here
			return false
		end
	end
		
	def initialize(obj)
		@video_id = 
		if KU6_SINGLE.match(obj.video_url) 
			obj.video_url.split('show/').last.split('.').first
		elsif KU6_ALBUM.match(obj.video_url) 
			obj.video_url.split('/show').last.split('/').last.split('.').first
		end
		@embed_url = "http://player.ku6.com/refer/#{@video_id}/v.swf"
	end

	def thumbnail_url
		"/images/blank_video.png"
	end

	def embed_html
		"<embed src=\"#{@embed_url}\" quality=\"high\" width=\"480\" height=\"400\" align=\"middle\" allowScriptAccess=\"always\" allowfullscreen=\"true\" type=\"application/x-shockwave-flash\"></embed>"
	end

end
