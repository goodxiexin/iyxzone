class Admin::GuestbooksController < UserBaseController
	ErrorElements = ['日志', '视频','照片','状态','活动','投票','工会','分享','游戏','推荐游戏','每日十闻','首页','个人主页','好友','站内信','通知','邀请','设置',    '其它']

  # GET /admin/guestbooks
  def index
    @guestbooks = Guestbook.all
  end

  # GET /admin/guestbooks/1
  def show
    @guestbook = Guestbook.find(params[:id])
  end

  # GET /admin/guestbooks/1/edit
  def edit
    @guestbook = Guestbook.find(params[:id])
  end

  # PUT /admin/guestbooks/1
  def update
    @guestbook = Guestbook.find(params[:id])

      if @guestbook.update_attributes(params[:guestbook])
        flash[:notice] = 'Guestbook was successfully updated.'
        redirect_to(admin_guestbook_url) 
      else
        render :action => "edit"
      end

  end

  # DELETE /admin/guestbooks/1
  def destroy
    @guestbook = Guestbook.find(params[:id])
    @guestbook.destroy
		redirect_to(guestbooks_url) 
	end

end

