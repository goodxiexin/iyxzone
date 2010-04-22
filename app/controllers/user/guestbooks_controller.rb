class User::GuestbooksController < UserBaseController
	
  def new
		@error_elements = Guestbook::ErrorElements
    @guestbook = Guestbook.new(:catagory => get_default)
  end

  def create
    @guestbook = Guestbook.new((params[:guestbook] || {}).merge({:user_id => current_user.id}))

    if @guestbook.save
			render :update do |page|
				page << "tip('17gaming感谢您的参与!')"
			end
    else
      render :update do |page|
        page << "error('用户汇报错误出错')"
      end
    end
  end


protected

	def get_default
		@uri = URI.parse(request.env['HTTP_REFERER'])
		@path = @uri.path
		case @path
		when /blog/
			return "日志" 
		when /video/
			return "视频"
		when /album/
			return "照片"
		when /status/
			return "状态"
		when /event/
			return "活动"
		when /poll/
			return "投票"
		when /guild/
			return "工会"
		when /share/
			return "分享"
		when /games/
			return "游戏"
		when /game_suggestion/
			return "推荐游戏"
		when /news/
			return "拾闻"
		when /home/
			return "首页"
		when /profile/
			return "个人主页"
		when /friend/
			return "好友"
		when /mail/
			return "站内信"
		when /invitation/
			return "邀请"
		when /setting/
			return "设置"
		else
			return "其它"
		end
	end

end
