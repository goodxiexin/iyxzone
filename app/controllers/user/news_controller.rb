class User::NewsController < UserBaseController

  layout 'app'

  increment_viewing 'news', 'id', :only => [:show]

  PER_PAGE = 10

  NewsCategory = ['all', 'text', 'video', 'picture']

  def index
  beginning_of_today = Time.now.beginning_of_day
	beginning_of_yesterday = 1.day.ago.beginning_of_day
	beginning_of_this_week = Time.now.beginning_of_week
    if params[:type].blank? || params[:type].to_i == 0
			if params[:time].blank? || params[:time].to_i == 1
				@news_list = News.find(:all, :conditions => ["created_at > ?", beginning_of_today],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			elsif params[:time].to_i == 2
				@news_list = News.find(:all, :conditions => ["created_at > ? and created_at < ?", beginning_of_yesterday, beginning_of_today],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			elsif params[:time].to_i == 3
				@news_list = News.find(:all, :conditions => ["created_at > ?", beginning_of_this_week],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			elsif params[:time].to_i == 4
				@news_list = News.find(:all, :conditions => ["created_at < ?", beginning_of_this_week],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			end
    else
			if params[:time].blank? || params[:time].to_i == 1
				@news_list = News.find(:all, :conditions => ["created_at > ? and news_type = ?", beginning_of_today, NewsCategory[params[:type].to_i]], :order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			elsif params[:time].to_i == 2
				@news_list = News.find(:all, :conditions => ["created_at > ? and created_at < ? and news_type = ?", beginning_of_yesterday, beginning_of_today, NewsCategory[params[:type].to_i]],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			elsif params[:time].to_i == 3
				@news_list = News.find(:all, :conditions => ["created_at > ? and news_type = ?", beginning_of_this_week, NewsCategory[params[:type].to_i]],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			elsif params[:time].to_i == 4
				@news_list = News.find(:all, :conditions => ["created_at < ? and news_type = ?", beginning_of_this_week,NewsCategory[params[:type].to_i]],:order => 'created_at DESC').paginate :page => params[:page], :per_page => PER_PAGE
			end
    end
  end

  def show
    @news = News.find(params[:id], :comments => [:commentable, {:poster => :profile}] )
    @random_news = News.random :limit => 5, :except => [@news]
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    render :action => "show_#{@news.news_type}_news"
  end

end
