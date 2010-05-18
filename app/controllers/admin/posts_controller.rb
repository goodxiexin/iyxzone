class Admin::PostsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @posts = Post.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @posts = Post.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @posts = Post.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @post.verify
      render_js_code "$('post_#{@post.id}').remove();"
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @post.unverify
      render_js_code "$('post_#{@post.id}').remove();"
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @post = Post.find(params[:id])
    end
  end
  
end
