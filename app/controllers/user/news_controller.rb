class User::NewsController < UserBaseController

  layout 'app'

  increment_viewing 'news', :only => [:show]

  PER_PAGE = 10

  Category = ['all', 'text', 'video', 'picture']

  TimeRange = [Time.now, Time.now.beginning_of_day, 1.day.ago.beginning_of_day, Time.now.beginning_of_week, Time.now.beginning_of_year]

  def index
    @i = params[:type].to_i
    @j = params[:time].to_i
    @news_list = News.type(Category[@i]).within(TimeRange[@j+1], TimeRange[@j]).order('created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
  end

  def show
    @news = News.find(params[:id], :include => [{:comments => [:commentable, {:poster => :profile}]}] )
    @random_news = News.random :limit => 5, :except => [@news]
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    render :action => "show_#{@news.news_type}_news"
  end

end
