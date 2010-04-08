class User::SharesController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  ShareCategory = ['all', 'blog', 'video', 'link', 'photo', 'album', 'poll', 'game', 'profile', 'topic']

  def hot
    @shares = Share.hot(ShareCategory[params[:type].to_i]).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def recent
    @shares = Share.recent(ShareCategory[params[:type].to_i]).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def index
		logger.error "---"*20 + "index" + "---"*20
		logger.error params
		logger.error "---"*20
    if params[:type].blank? || params[:type].to_i == 0
      @sharings = @user.sharings.paginate :page => params[:page], :per_page => PER_PAGE
    else
      @sharings = eval("@user.#{ShareCategory[params[:type].to_i]}_sharings").paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def friends
		logger.error "---"*20 + "friends" + "---"*20
		logger.error params
		logger.error "---"*20
    if params[:type].blank? || params[:type].to_i == 0
      @sharings = current_user.friend_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    else
      @sharings = current_user.friend_sharings(ShareCategory[params[:type].to_i]).paginate :page => params[:page], :per_page => PER_PAGE
    end
		logger.error  @sharings.to_yaml

  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
    end
  end
  
end
