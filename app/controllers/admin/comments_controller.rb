class Admin::CommentsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @comments = Comment.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @comments = Comment.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @comments = Comment.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @comment.verify
      render :update do |page|
        page << "$('comment_#{@comment.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @comment.unverify
      render :update do |page|
        page << "$('comment_#{@comment.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @comment = Comment.find(params[:id])
    end
  end
  
end
