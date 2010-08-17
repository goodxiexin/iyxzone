class User::PrivacySettingController < UserBaseController

  layout 'app'

  def show
  end

  def edit
    case params[:type].to_i
    when 0
      render :action => "profile_privacy"
    when 1
      render :action => "going_privacy"
    when 2
      render :action => "outside_privacy"
    when 3
      render :action => "qq_privacy", :layout => false
    when 4
      render :action => "phone_privacy", :layout => false
    when 5
      render :action => "website_privacy", :layout => false
    end
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
    @setting = current_user.privacy_setting
  end

end
