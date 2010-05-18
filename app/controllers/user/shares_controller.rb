class User::SharesController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  ShareCategory = ['all', 'blog', 'video', 'link', 'photo', 'album', 'poll', 'game', 'profile', 'topic', 'news']

  def hot
    @shares = Share.hot(@category).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def recent
    @shares = Share.recent(@category).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def index
    if params[:type].to_i == 0 and !params[:sharing_id].blank? and !params[:reply_to].blank?
      @reply_to = User.find(params[:reply_to])
      @sharing = Sharing.find(params[:sharing_id])
      params[:page] = @user.sharings.index(@sharing) / PER_PAGE + 1
    end
    @sharings = eval("@user.#{@category}_sharings").paginate :page => params[:page], :per_page => PER_PAGE
  end

  def friends
    @sharings = Sharing.by(current_user.friend_ids).in(@category).paginate :page => params[:page], :per_page => PER_PAGE
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
      @category = ShareCategory[params[:type].to_i]
    elsif ['hot', 'recent', 'friends'].include? params[:action]
      @category = ShareCategory[params[:type].to_i]
    end
  end
  
end
