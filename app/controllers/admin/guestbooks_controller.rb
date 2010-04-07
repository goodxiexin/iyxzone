class Admin::GuestbooksController < UserBaseController
	ErrorElements = ['日志', '视频','照片','状态','活动','投票','工会','分享','游戏','推荐游戏','每日十闻','首页','个人主页','好友','站内信','通知','邀请','设置',    '其它']

  # GET /admin/guestbooks
  # GET /admin/guestbooks.xml
  def index
    @guestbooks = Guestbook.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @guestbooks }
    end
  end

  # GET /admin/guestbooks/1
  # GET /admin/guestbooks/1.xml
  def show
    @guestbook = Guestbook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guestbook }
    end
  end

  # GET /admin/guestbooks/1/edit
  def edit
    @guestbook = Guestbook.find(params[:id])
  end

  # PUT /admin/guestbooks/1
  # PUT /admin/guestbooks/1.xml
  def update
    @guestbook = Guestbook.find(params[:id])

    respond_to do |format|
      if @guestbook.update_attributes(params[:guestbook])
        flash[:notice] = 'Guestbook was successfully updated.'
        format.html { redirect_to(admin_guestbook_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guestbook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/guestbooks/1
  # DELETE /admin/guestbooks/1.xml
  def destroy
    @guestbook = Guestbook.find(params[:id])
    @guestbook.destroy

    respond_to do |format|
      format.html { redirect_to(guestbooks_url) }
      format.xml  { head :ok }
    end
  end

protected

	def get_default
		@uri = URI.parse(request.url)
		@host = @uri.host
		@path = @uri.path
		logger.error(@path)
		logger.error(@host)
	end

end
