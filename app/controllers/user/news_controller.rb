class User::NewsController < UserBaseController

  layout 'app'

  increment_viewing 'news', :only => [:show]

  def index
    @news_list = News.find(:all, :order => 'created_at DESC').paginate :page => params[:page], :per_page => 10
  end

  def text
    @news_list = News.text.find(:all).paginate :page => params[:page], :per_page => 10
    render(:index)
  end

  def video
    @news_list = News.video.find(:all).paginate :page => params[:page], :per_page => 10
    render(:index)
  end

  def pic
    @news_list = News.pic.find(:all).paginate :page => params[:page], :per_page => 10
    render(:index)
  end

  def show
    @news = News.find(params[:id])
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

end
