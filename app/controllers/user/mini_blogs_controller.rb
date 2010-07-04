class User::MiniBlogsController < UserBaseController

  layout 'app'

  PER_PAGE = 20

  def public
    
  end

  # 按照转贴数量
  def hot
    @mini_blogs = MiniBlog.hot.paginate :page => params[:page], :per_page => PER_PAGE
  end

  # 按照回复数量
  def sexy
    @mini_blogs = MiniBlog.sexy.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def index
    @mini_blogs = @user.mini_blogs.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def friends
    @mini_blogs = current_user.follows.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def destroy
    if @mini_blog.destroy
      render_js_code "Effect.BlindUp($('mini_blog_#{@mini_blog.id}'));"
    else
      render_js_error
    end
  end

protected

  def setup
    if ['index'].include? params[:action]
      @user = User.find(params[:uid])
    elsif ['destroy'].include? params[:action]
      @mini_blog = current_user.mini_blogs.find(params[:id])
    end
  end
end
