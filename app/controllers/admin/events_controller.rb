class Admin::EventsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @events = Event.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @events = Event.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @events = Event.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @event.verify
      render :update do |page|
        page << "$('event_#{@event.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @event.unverify
      render :update do |page|
        page << "$('event_#{@event.id}').remove();"
      end
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @event = Event.find(params[:id])
    end
  end
  
end
