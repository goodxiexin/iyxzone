class Admin::PollsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @polls = Poll.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @polls = Poll.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @polls = Poll.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @poll.verify
      render :update do |page|
        page << "$('poll_#{@poll.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @poll.unverify
      render :update do |page|
        page << "$('poll_#{@poll.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @poll = Poll.find(params[:id])
    end
  end
  
end
