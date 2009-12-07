class NoticesController < ApplicationController

	before_filter :login_required, :setup

	before_filter :owner_required, :only => [:read_multiple]

	def index
    @notices = current_user.notices
    render :action => 'index', :layout => 'app'
	end

	def first_ten
		@notices = current_user.notices.unread.find(:all, :limit => 10)
		render :partial => 'notices', :object => @notices
	end

	def read
		@notices = current_user.notices.unread.find_all {|n| n.has_same_source? @notice }
		Notice.update_all("notices.read = 1", {:user_id => current_user.id, :id => @notices.map(&:id)})
		@notices = current_user.notices.unread.find(:all, :limit => 10)
		render :partial => 'notices', :object => @notices
	end

protected

	def setup
		if ["read"].include? params[:action] 
			@notice = current_user.notices.find(params[:id])
			@user = @notice.user
		end
	rescue
		not_found
	end

end
