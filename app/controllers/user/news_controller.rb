class User::NewsController < UserBaseController
  layout 'app'
  def index
    session[:news_type] = 'index'
   # @news_list = News.find(:all, :limit => 10, :order => 'created_at DESC')
  end

  def text
    session[:news_type] = 'text'
    filter_type "文字"
    render(:index)
  end

  def video
    session[:news_type] = 'video'
    filter_type "视频"
    render(:index)
  end

  def pic
    session[:news_type] = 'pic'
    filter_type "图片"
    render(:index)
  end

  def show
    @comments = @news.comments
  end

  protected
  def setup
    if['show'].include? params[:action]
      @news = News.find(params[:id])
      @news.viewings_count += 1
      @news.save!
    elsif ['index', 'text', 'video', 'pic'].include? params[:action]
      @news_list = News.find(:all, :limit => 10, :order => 'created_at DESC') 
    end
  rescue
    not_found
  end

  def filter_type type
    @news_list.each do|n|
      if (n.news_type != type)
        @news_list.delete(n)
      end
    end
  end
end
