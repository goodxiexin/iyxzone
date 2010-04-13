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
    if params[:type].blank? || params[:type].to_i == 0
      if !params[:sharing_id].blank? and !params[:reply_to].blank?
        @reply_to = User.find(params[:reply_to])
        @sharing = Sharing.find(params[:sharing_id])
        params[:page] = @user.sharings.index(@sharing) / 10 + 1
      end
      @sharings = @user.sharings.paginate :page => params[:page], :per_page => PER_PAGE
    else
      @sharings = eval("@user.#{ShareCategory[params[:type].to_i]}_sharings").paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def friends
    if params[:type].blank? || params[:type].to_i == 0
      @sharings = current_user.friend_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    else
      @sharings = current_user.friend_sharings(ShareCategory[params[:type].to_i]).paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
    end
  end
  
end
