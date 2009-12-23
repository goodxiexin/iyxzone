class User::PrivacySettingController < ApplicationController

  layout 'app'

  before_filter :login_required, :catch_setting

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
    end
  end

  def update
    if @setting.update_attributes(params[:setting])
      flash[:notice] = "设置保存成功"
      redirect_to privacy_setting_url
    end
  end

protected

  def catch_setting
    @setting = current_user.privacy_setting
  end

end
