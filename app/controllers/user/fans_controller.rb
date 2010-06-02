class User::FansController < UserBaseController

  layout 'app'

  def index
    @user = User.find(params[:uid])
    @fans = @user.fans.paginate :page => params[:page], :per_page => 18
  end

  def destroy
    @fanship = current_user.fanships.find_by_fan_id(params[:id])
    if @fanship.destroy
      render_js_code "$('fan_#{@fanship.fan_id}').remove();"
    else
      render_js_error
    end
  end

end
