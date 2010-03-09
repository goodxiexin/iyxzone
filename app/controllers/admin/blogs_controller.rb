class Admin::BlogsController < AdminBaseController

  def index
    @blogs = Blog.unverified.paginate :page => params[:page], :per_page => 20
  end
  
  def accept
    @blogs = Blog.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @blogs = Blog.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  def verify
    if @blog.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @blog.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @blog = Blog.find(params[:id])
    end
  end
  
end
