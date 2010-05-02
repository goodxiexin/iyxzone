class Admin::BlogsController < AdminBaseController

  def index
    @blogs = Blog.unverified
  end
  
  def accept
    @blogs = Blog.accepted
  end
  
  def reject
    @blogs = Blog.rejected
  end

  def verify
    if @blog.verify
      render :update do |page|
        page << "$('blog_#{@blog.id}').remove();"
      end
    else
      err
    end
  end
  
  # reject
  def unverify
    if @blog.unverify
      render :update do |page|
        page << "$('blog_#{@blog.id}').remove();"
      end
    else
      err
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @blog = Blog.find(params[:id])
    end
  end
  
end
