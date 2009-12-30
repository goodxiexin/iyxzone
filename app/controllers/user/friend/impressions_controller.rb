class User::Friend::ImpressionsController < ApplicationController

	layout 'app'

	before_filter :login_required

	def index
		@friends = current_user.friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
	end

end
