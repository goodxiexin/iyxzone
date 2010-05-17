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
      render :json => {:id => @news.id}
    else
      render :json => {:id => -1}
    end
  end

  def edit
    render :action => "edit_#{@news.news_type}_news"
  end

  def update
    if @news.update_attributes((params[:news] || {}).merge({:poster_id => current_user.id}))
      render :json => {:id => @news.id}
    else
      render :json => {:id => -1}
    end
  end

  def destroy
    if @news.destroy
      render_js_code "$('news_#{@news.id}').remove();"
    else
      render_js_error
    end
  end

protected

  def setup
    if ['edit','update', 'destroy'].include? params[:action]
      @news = News.find(params[:id])
    end
  end

end
