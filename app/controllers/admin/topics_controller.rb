class Admin::TopicsController < AdminBaseController

  def index
    case params[:type].to_i
    when 0
      @topics = Topic.unverified.paginate :page => params[:page], :per_page => 20
    when 1
      @topics = Topic.accepted.paginate :page => params[:page], :per_page => 20
    when 2
      @topics = Topic.rejected.paginate :page => params[:page], :per_page => 20
    end
  end

  def verify
    if @topic.verify
      render_js_code "$('topic_#{@topic.id}').remove();"
    else
      render_js_error
    end
  end
  
  # reject
  def unverify
    if @topic.unverify
      render_js_code "$('topic_#{@topic.id}').remove();"
    else
      render_js_error
    end
  end
  
  
protected

  def setup
    if ["verify", "unverify"].include? params[:action]
      @topic = Topic.find(params[:id])
    end
  end
  
end
