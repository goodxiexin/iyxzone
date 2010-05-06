class Admin::StatusesController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @statuses = Status.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @statuses = Status.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @statuses = Status.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @status.verify
      render :update do |page|
        page << "$('status_#{@status.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @status.unverify
      render :update do |page|
        page << "$('status_#{@status.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @status = Status.find(params[:id])
    end
  end
  
end
