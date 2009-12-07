class FeedDeliveriesController < ApplicationController

	before_filter :login_required, :setup, :recipient_required

	def destroy
		@feed_delivery.destroy
		render :update do |page|
			page << "Effect.BlindUp($('feed_delivery_#{@feed_delivery.id}'));" 
		end
	end

protected

	def setup
		@feed_delivery = FeedDelivery.find(params[:id])
	rescue
		not_found
	end

	def recipient_required
		logger.error @feed_delivery.recipient.class.to_s
    if @feed_delivery.recipient_type == 'User'
			@feed_delivery.recipient == current_user || not_found
		else
			@feed_delivery.recipient.user == current_user || not_found
		end
	end

end
