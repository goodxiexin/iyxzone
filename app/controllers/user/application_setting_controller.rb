class User::ApplicationSettingController < UserBaseController

	layout 'app'

  ConfigType = ['blog', 'video', 'photo', 'poll','event', 'guild', 'sharing']
  
  ConfigName = ['日志', '视频', '照片', '投票', '活动', '公会', '分享']

	def show
	  @applications = Application.all
  end

	def edit
    @type = ConfigType[params[:type].to_i]
    @name = ConfigName[params[:type].to_i]
    render :action => 'edit', :layout => false
	end

	def update
		if @setting.update_attributes(params[:setting])
			render_js_code "facebox.close();"
		else
      render_js_error
    end	
	end

protected

	def setup
		@setting = current_user.application_setting	
	end

end
