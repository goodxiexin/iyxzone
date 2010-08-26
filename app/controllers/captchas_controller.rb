class CaptchasController < ApplicationController

  def new
    @captcha = Captcha.random(:limit => 1).first
    render :json => {:src => @captcha.image_filename, :token => @captcha.token}
  end

end
