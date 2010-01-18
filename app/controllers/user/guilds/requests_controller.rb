class User::Guilds::RequestsController < UserBaseController

  layout 'app'

  def new
    render :action => 'new', :layout => false
  end

  def create
    @request = @guild.requests.build(:user_id => current_user.id, :status => params[:status])
    unless @request.save
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def accept
    if @request.accept_request 
      render :update do |page|
        page << "alert('成功'); $('guild_request_option_#{@request.id}').innerHTML = '已接受';"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def decline
    if @request.destroy
      render :update do |page|
        page << "facebox.close(); $('guild_request_option_#{@request.id}').innerHTML = '已拒绝';"
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['new', 'create'].include? params[:action]
      @guild = Guild.find(params[:guild_id])
      @user = @guild.president
    elsif ['accept', 'decline'].include? params[:action]
      @guild = current_user.guilds.find(params[:guild_id])
      @request = @guild.requests.find(params[:id])
    end
  rescue
    not_found
  end

end
