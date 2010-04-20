class Admin::NewsController < AdminBaseController

  def new
    @news = News.new
    render :action => "new_#{params[:type]}_news"
  end

  def index
    @news_list = News.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 10
  end

  def create
    @news = News.new((params[:news] || {}).merge({:poster_id => current_user.id}))
    if @news.save
      render :update do |page|
        page.redirect_to admin_news_index_url
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

  def edit
    render :action => "edit_#{@news.news_type}_news"
  end

  def update
    if @news.update_attributes((params[:news] || {}).merge({:poster_id => current_user.id}))
      render :update do |page|
        page.redirect_to :action => :index
      end
    else
      page << "error('发生错误');"
    end
  end

  def destroy
    if @news.destroy
      render :update do |page|
        page << "$('news_#{@news.id}').remove();"
      end
    else
      render :update do |page|
        page << "error('删除新闻出错')"
      end
    end
  end

protected

  def setup
    if ['edit','update', 'destroy'].include? params[:action]
      @news = News.find(params[:id])
    end
  end

end
