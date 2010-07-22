class User::FeedDeliveriesController < UserBaseController

  FetchSize = 20

  def index
    @fetch_size = params[:fetch].nil? ? FetchSize : params[:fetch].to_i
    @offset = params[:idx].nil? ? 0 : @fetch_size*params[:idx].to_i
    @feed_deliveries = @recipient.feed_deliveries.category(@category).offset(@offset).limit(@fetch_size).all
    render :partial => 'group_deliveries', :locals => {:feed_deliveries => @feed_deliveries}
  end

	def destroy
		if @feed_delivery.destroy
		  render_js_code "Effect.BlindUp($('feed_delivery_#{@feed_delivery.id}'));" 
    else
      render_js_error
    end
	end

protected

	def setup
		if ['index', 'more'].include? params[:action]
      @recipient = params[:recipient_type].camelize.constantize.find(params[:recipient_id])
      @category = params[:category].blank? ? 'all' : params[:category]
    elsif ['destroy'].include? params[:action]
      @feed_delivery = FeedDelivery.find(params[:id])
      require_delete_privilege @feed_delivery
    end
  end

  def require_delete_privilege feed_delivery
    feed_delivery.is_deleteable_by?(current_user) || render_js_error
  end

end
