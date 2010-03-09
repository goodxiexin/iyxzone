class Admin::CommentsController < AdminBaseController

  def index
    @comments = Comment.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @comments = Comment.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @comments = Comment.rejected.paginate :page => params[:page], :per_page => 20
  end
  
  def show
  end
  
  def destroy
  end

  # accept
  def verify
    if @comment.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @comment.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @comment = Comment.find(params[:id])
    end
  end
  
end
