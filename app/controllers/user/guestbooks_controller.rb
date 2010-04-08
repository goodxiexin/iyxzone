class User::GuestbooksController < UserBaseController
	ErrorElements = ['日志', '视频','照片','状态','活动','投票','工会','分享','游戏','推荐游戏','每日十闻','首页','个人主页','好友','站内信','通知','邀请','设置',    '其它']


  # GET /guestbooks/new
  def new
		@error_elements = ErrorElements
    @guestbook = Guestbook.new(:catagory => get_default)
  end


  # POST /guestbooks
  def create
    @guestbook = Guestbook.new(params[:guestbook])
		if params['priority1'] 
			@guestbook.priority = 1
		elsif params['priority2'] 
			@guestbook.priority = 2
		end

		@guestbook.user_id = @current_user.id;
		logger.error(@guestbook.catagory);

      if @guestbook.save
					render :update do |page|
						page << "tip('17gaming感谢您的参与!')"
					end
      else
        	logger.error "用户汇报错误出错"
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
		when /sharing/
			return "分享"
		when /games/
			return "游戏"
		when /game_suggestion/
			return "推荐游戏"
		when /news/
			return "每日十闻"
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
