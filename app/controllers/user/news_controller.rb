class User::NewsController < UserBaseController

  layout 'app'

  increment_viewing 'news', 'id', :only => [:show]

  PER_PAGE = 10

  NewsCategory = ['all', 'text', 'video', 'picture']

  def index
    if params[:type].blank? || params[:type].to_i == 0
      @news_list = News.all(:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
    else
      @news_list = News.all(:conditions => {:news_type => NewsCategory[params[:type].to_i]}, :order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def show
    @news = News.find(params[:id], :comments => [:commentable, {:poster => :profile}] )
    @random_news = News.random :limit => 5, :except => [@news]
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    render :action => "show_#{@news.news_type}_news"
  end

end
