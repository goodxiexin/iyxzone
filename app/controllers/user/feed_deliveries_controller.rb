class User::FeedDeliveriesController < UserBaseController

	def destroy
		if @feed_delivery.destroy
		  render_js_code "Effect.BlindUp($('feed_delivery_#{@feed_delivery.id}'));" 
    else
      render_js_error
    end
	end

protected

	def setup
		@feed_delivery = FeedDelivery.find(params[:id])
    unless @feed_delivery.is_deleteable_by?(current_user)
      render_js_error '没有删除的权限'
    end
  end

end
