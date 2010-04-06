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
      @shares = @user.shares.paginate :page => params[:page], :per_page => PER_PAGE
    else
      @shares = eval("@user.#{ShareCategory[params[:type].to_i]}_shares").paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def friends
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
    end
  end
  
end
