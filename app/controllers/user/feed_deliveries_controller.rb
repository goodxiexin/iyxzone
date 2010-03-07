class User::FeedDeliveriesController < UserBaseController

	def destroy
		if @feed_delivery.destroy
		  render :update do |page|
			  page << "Effect.BlindUp($('feed_delivery_#{@feed_delivery.id}'));" 
		  end
    else
      render :update do |page|
        page << "error('发生错误')"
      end
    end
	end

protected

	def setup
		@feed_delivery = FeedDelivery.find(params[:id])
	  require_owner @feed_delivery.recipient
  end

end
