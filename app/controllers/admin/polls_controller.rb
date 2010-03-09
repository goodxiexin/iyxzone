class Admin::PollsController < AdminBaseController

  def index
    @polls = Poll.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @polls = Poll.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @polls = Poll.rejected.paginate :page => params[:page], :per_page => 20
  end

  def show
  end

  def destroy
  end

  # accept
  def verify
    if @poll.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @poll.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @poll = Poll.find(params[:id])
    end
  end
  
end
