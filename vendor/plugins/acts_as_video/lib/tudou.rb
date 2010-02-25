class Tudou

	# http://www.tudou.com/programs/view/gy0zIm5Qb54/
	# <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="450" height="363" align="middle"><param name="movie" value="http://www.tudou.com/player/outside/beta_player.swf?iid=46740833"></param><param name="allowScriptAccess" value="always"></param><param name="allowFullScreen" value="true"></param><param name="quality" value="high"></param><param name="wmode" value="transparent"></param><embed src="http://www.tudou.com/player/outside/beta_player.swf?iid=46740833" quality="high" width="450" height="363" align="middle" allowScriptAccess="always" allowFullScreen="true" wmode="transparent" type="application/x-shockwave-flash"></embed></object>
	TUDOU_SINGLE 	= /http:\/\/www\.tudou\.com\/programs\/view\/[\w]*\/?/
	# http://www.tudou.com/playlist/playindex.do?lid=7188107&iid=37376153&cid=22

	TUDOU_ALBUM 	= /http:\/\/www\.tudou\.com\/playlist\/playindex\.do\?lid=[\d]*&iid=[\d]*&cid=[\d]*/
	# http://hd.tudou.com/program/23631/ 
	TUDOU_HD			= /http:\/\/hd\.tudou\.com\/program\/[\d]*\//

	include HTTParty

	format :json

	base_uri ''
	
	def self.identify_url(video_url)
		if TUDOU_SINGLE.match(video_url)
			return true
		elsif TUDOU_ALBUM.match(video_url)
			return true
		elsif TUDOU_HD.match(video_url)
			return true
		end
	end

	def initialize(obj)
		@video_id = 
		if TUDOU_SINGLE.match(obj.video_url)
			nil
		elsif TUDOU_ALBUM.match(obj.video_url)
			obj.video_url.split('iid=').last.split('&cid').first
		end
		@embed_url = "http://www.tudou.com/player/outside/beta_player.swf?iid=#{@video_id}"
	end

	def thumbnail_url
		"/images/blank.gif"
	end

	def embed_html
	'<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="450" height="363" align="middle"><param name="movie" value="' + @embed_url + '"></param><param name="allowScriptAccess" value="always"></param><param name="allowFullScreen" value="true"></param><param name="quality" value="high"></param><param name="wmode" value="transparent"></param><embed src="' +@video_id + '" quality="high" width="450" height="363" align="middle" allowScriptAccess="always" allowFullScreen="true" wmode="transparent" type="application/x-shockwave-flash"></embed></object>'
	#	"<object classid width=\"450\" height=\"363\"><param name=\"movie\" value=\""+ @video_id +"\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><param name=\"wmode\" value=\"opaque\"></param><embed src=\""+ @embed_url+"\"type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" wmode=\"opaque\" width=\"420\" height=\"363\"></embed></object>"
	end	

end
