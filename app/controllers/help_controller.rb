class HelpController < ApplicationController
  layout 'help'

	def about_us
	end

	def app_info
		@applications = Application.all
	end

	def contact_info
	end

	def privacy_info
	end
end
