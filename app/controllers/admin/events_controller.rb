class Admin::EventsController < AdminBaseController

  def index
    @events = Event.unverified.paginate :page => params[:page], :per_page => 20
  end

  def accept
    @events = Event.accepted.paginate :page => params[:page], :per_page => 20
  end
  
  def reject
    @events = Event.rejected.paginate :page => params[:page], :per_page => 20
  end
  
  def show
  end

  def destroy
  end

  
  # accept
  def verify
    if @event.verify
      succ
    else
      err
    end
  end
  
  # reject
  def unverify
    if @event.unverify
      succ
    else
      err
    end
  end
  
  
protected

  def setup
    if ["show", "destroy", "verify", "unverify"].include? params[:action]
      @event = Event.find(params[:id])
    end
  end
end
