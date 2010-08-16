class User::MailSettingController < UserBaseController

  layout 'app'

  def edit
  end

  def update
    if @setting.update_attributes(params[:setting])
      render :json => {:code => 1}
    else
			render :json => {:code => 0}
    end
  end

protected

  def setup
    @setting = current_user.mail_setting
  end

end
