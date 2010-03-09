class Admin::TagsController < AdminBaseController

  def index
    @tags = Tag.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @tags = Tag.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @tags = Tag.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  # accept
  def verify
    if @tag.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @tag.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @tag = Tag.find(params[:id])
    end
  end
  
end
