class AddAppAbout < ActiveRecord::Migration
  def self.up
		rizhi = Application.find(:first, :conditions => "name = '日志'")
		rizhi.about = '<object width="600" height="450"><param name="allowscriptaccess" value="always"></param><param name="wmode" value="window"></param><param name="movie" value="http://6.cn/p/9NPsjLr7vwcZ1En9U1eCZw.swf"></param><embed src="http://6.cn/p/9NPsjLr7vwcZ1En9U1eCZw.swf" width="600" height="450" allowscriptaccess="always" wmode="window"  type="application/x-shockwave-flash"></embed></object>'
		rizhi.save
		toupiao = Application.find(:first, :conditions => "name = '投票'") 
		toupiao.about = '<object width="600" height="450"><param name="allowscriptaccess" value="always"></param><param name="wmode" value="window"></param><param name="movie" value="http://6.cn/p/Zs7AFz0SFvh9eWcvV4aGzw.swf"></param><embed src="http://6.cn/p/Zs7AFz0SFvh9eWcvV4aGzw.swf" width="600" height="450" allowscriptaccess="always" wmode="window"  type="application/x-shockwave-flash"></embed></object>'
		toupiao.save
		shipin = Application.find(:first, :conditions => "name = '视频'")
		shipin.about = '<object width="600" height="450"><param name="allowscriptaccess" value="always"></param><param name="wmode" value="window"></param><param name="movie" value="http://6.cn/p/7sivMbaf1g/_XNM0At71_w.swf"></param><embed src="http://6.cn/p/7sivMbaf1g/_XNM0At71_w.swf" width="600" height="450" allowscriptaccess="always" wmode="window"  type="application/x-shockwave-flash"></embed></object>'
		shipin.save
		huodong = Application.find(:first, :conditions => "name = '活动'")
		huodong.about = '<object width="600" height="450"><param name="allowscriptaccess" value="always"></param><param name="wmode" value="window"></param><param name="movie" value="http://6.cn/p/wYZMZRM5F12yK3DHb936WA.swf"></param><embed src="http://6.cn/p/wYZMZRM5F12yK3DHb936WA.swf" width="600" height="450" allowscriptaccess="always" wmode="window"  type="application/x-shockwave-flash"></embed></object>'
		huodong.save
		gonghui = Application.find(:first, :conditions => "name = '公会'") 
		gonghui.about = '<object width="600" height="450"><param name="allowscriptaccess" value="always"></param><param name="wmode" value="window"></param><param name="movie" value="http://6.cn/p/lY5ygYmsvrmRTSNSnVnDaQ.swf"></param><embed src="http://6.cn/p/lY5ygYmsvrmRTSNSnVnDaQ.swf" width="600" height="450" allowscriptaccess="always" wmode="window"  type="application/x-shockwave-flash"></embed></object>'
		gonghui.save
		fenxiang = Application.find(:first, :conditions => "name = '分享'")
		fenxiang.about = '<object width="600" height="450"><param name="allowscriptaccess" value="always"></param><param name="wmode" value="window"></param><param name="movie" value="http://6.cn/p/JdYm/jKehgAcVFjAMDnnDQ.swf"></param><embed src="http://6.cn/p/JdYm/jKehgAcVFjAMDnnDQ.swf" width="600" height="450" allowscriptaccess="always" wmode="window"  type="application/x-shockwave-flash"></embed></object>'
		fenxiang.save
  end

  def self.down
		rizhi = Application.find(:first, :conditions => "name = '日志'")
		rizhi.about = ''
		rizhi.save
		toupiao = Application.find(:first, :conditions => "name = '投票'") 
		toupiao.about = ''
		toupiao.save
		shipin = Application.find(:first, :conditions => "name = '视频'")
		shipin.about = ''
		shipin.save
		huodong = Application.find(:first, :conditions => "name = '活动'")
		huodong.about = ''
		huodong.save
		gonghui = Application.find(:first, :conditions => "name = '公会'") 
		gonghui.about = ''
		gonghui.save
		fenxiang = Application.find(:first, :conditions => "name = '分享'")
		fenxiang.about = ''
		fenxiang.save
  end
end
