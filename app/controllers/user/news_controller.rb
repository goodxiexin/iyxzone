class User::NewsController < UserBaseController

  layout 'app'

  increment_viewing 'news', 'id', :only => [:show]

  PER_PAGE = 10

  NewsCategory = ['all', 'text', 'video', 'picture']

  TimeRange = [Time.now, Time.now.beginning_of_day, 1.day.ago.beginning_of_day, Time.now.beginning_of_week, Time.now.beginning_of_year]

  def index
    if params[:type].to_i == 0
      @news_list = News.all(:conditions => ["created_at > ? and created_at < ?", TimeRange[params[:time].to_i+1], TimeRange[params[:time].to_i]], :order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
    else
      @news_list = News.all(:conditions => ["created_at > ? and created_at < ? and news_type = ?", TimeRange[params[:time].to_i+1], TimeRange[params[:time].to_i], NewsCategory[params[:type].to_i]], :order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def show
    @news = News.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}] )
    @random_news = News.random :limit => 5, :except => [@news]
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    render :action => "show_#{@news.news_type}_news"
  end

end
