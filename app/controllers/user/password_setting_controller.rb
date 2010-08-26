class User::PasswordSettingController < UserBaseController

  layout 'app'

  before_filter :check_captcha, :only => [:update]

  def edit
  end

  def update
    if current_user.authenticated? params[:old_password]
      current_user.password = params[:password]
      if current_user.save
        render :json => {:code => 1} 
      else
        render :json => {:code => 0}
      end
    else
      render :json => {:code => 2}
    end
  end

protected

  def check_captcha
    if !captcha_valid?
      render :json => {:code => 222}
    end
  end

end

