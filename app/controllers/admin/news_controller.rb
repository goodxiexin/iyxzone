class Admin::NewsController < AdminBaseController
  increment_viewing 'news', :only => [:show]
  def new
    @news = News.new
  end

  def create
    @news = News.create(params[:news]).merge({:poster_id => current_user.id})
    if @news.save
      render :update do |page|
        page.redirect_to user_news_url 
      end
    else
      render :update do |page|
        page << "error(@news.errors.on_base);"
      end
    end
  end

  def edit
    @news = News.find(params[:id])
    if @news.nil?
      render :update do |page|
        page << "error('找不到该新闻')"
      end
    end

  end

  def update
    if @blog.update_attributes(params[:news] || {})
      render :update do |page|
        page.redirect_to user_news_url
      end
    else
      page << "error(@news.errors.on_base)"
    end
  end

  def destroy
    @news = News.find(params[:id])
    if @news.nil?
      page << "error('找不到该新闻')"
    else
      @news.destroy
    end
  end

end
