class User::StatusesController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  PREFETCH = [{:first_comment => [:commentable, :poster]}, {:last_comment => [:commentable, :poster]}, {:poster => :profile}]

  def index
    if !params[:status_id].blank? and !params[:reply_to].blank?
      @reply_to = User.find(params[:reply_to])
      @status = Status.nonblocked.find(params[:status_id])
      params[:page] = @user.statuses.index(@status) / PER_PAGE + 1 if @status
    end
    @statuses = @user.statuses.nonblocked.paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def friends
    @statuses = Status.by(current_user.friend_ids).nonblocked.paginate :page => params[:page], :per_page => PER_PAGE, :include => PREFETCH
  end

  def create
    @status = current_user.statuses.build(params[:status] || {})

    unless @status.save
      render_js_error '保存时发生错误'
		end
  end

  def destroy
    if @status.destroy
      render :update do |page|
        page << "facebox.close();$('status_#{@status.id}').remove();"
      end
    else
      render_js_error '发生错误'
    end
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user      
    elsif ["destroy"].include? params[:action]
      @status = Status.find(params[:id])
      require_owner @status.poster
    end
  end

end
