class User::FansController < UserBaseController

  layout 'app'

  def index
    @fans = @user.fans.paginate :page => params[:page], :per_page => 18
  end

  def destroy
    if @fanship.destroy
      render_js_code "$('fan_#{@fanship.fan_id}').remove();"
    else
      render_js_error
    end
  end

protected 

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
      @user.is_idol || render_not_found
    elsif ["destroy"].include? params[:action]
      @fanship = current_user.fanships.find_by_fan_id(params[:id])
      !@fanship.blank? || render_not_found
    end
  end

end
