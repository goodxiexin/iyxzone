class Admin::BlogsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @blogs = Blog.unverified.paginate :page => params[:page], :per_page => 20, :conditions => {:draft => 0}
    when 1
      @blogs = Blog.accepted.paginate :page => params[:page], :per_page => 20, :conditions => {:draft => 0}
    when 2
      @blogs = Blog.rejected.paginate :page => params[:page], :per_page => 20, :conditions => {:draft => 0}
    end
  end

  def verify
    if @blog.verify
      render :update do |page|
        page << "$('blog_#{@blog.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @blog.unverify
      render :update do |page|
        page << "$('blog_#{@blog.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @blog = Blog.find(params[:id])
    end
  end
  
end
