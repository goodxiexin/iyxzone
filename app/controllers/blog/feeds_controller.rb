class Blog::FeedsController < ApplicationController

	layout 'app'

	before_filter :login_required, :setup

	def index
		@feed_items = current_user.blog_feed_items.paginate :page => params[:page], :per_page => 10
	end

protected

	def setup
		@user = current_user
	end


end
