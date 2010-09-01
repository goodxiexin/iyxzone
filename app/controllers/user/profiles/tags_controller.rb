class User::Profiles::TagsController < User::TagsController

	def index
		@profile = Profile.find(params[:profile_id])
		render :partial => 'profile_tag', :locals => {:profile => @profile}
	end

protected
	
	def get_taggable
		@taggable = Profile.find(params[:profile_id])
	end

end
