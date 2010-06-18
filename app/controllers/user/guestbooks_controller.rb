class User::GuestbooksController < UserBaseController
	
  def new
		@error_elements = Guestbook::ErrorElements
    @guestbook = Guestbook.new(:catagory => get_default)
  end

  def create
    @guestbook = Guestbook.new((params[:guestbook] || {}).merge({:user_id => current_user.id}))

    if @guestbook.save
			render_js_tip '17gaming感谢您的参与!'
    else
      render_js_error '用户汇报错误出错'
    end
  end


protected

	def get_default
		@uri = URI.parse(request.env['HTTP_REFERER'])
		@path = @uri.path 
		case @path
		when /blog/
			 "日志" 
		when /video/
			 "视频"
		when /album/
			 "照片"
		when /status/
			 "状态"
		when /event/
			 "活动"
		when /poll/
			 "投票"
		when /guild/
			 "公会"
		when /sharing/
			 "分享"
		when /games/
			 "游戏"
		when /game_suggestion/
			 "推荐游戏"
		when /news/
			 "拾闻"
		when /home/
			 "首页"
		when /profile/
			 "个人主页"
		when /friend/
			 "好友"
		when /mail/
			 "站内信"
		when /invitation/
			 "邀请"
		when /setting/
			 "设置"
		else
			 "其它"
		end
  rescue URI::InvalidURIError
    "其他"
	end

end
