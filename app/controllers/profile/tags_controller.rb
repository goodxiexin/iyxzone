class Profile::TagsController < ApplicationController

	before_filter :login_required, :setup

	before_filter :taggable_required, :only => [:create]

	before_filter :owner_required, :only => [:destroy]

	def create
		@tagging.destroy unless @tagging.nil?
		@profile.taggings.create(:tag_id => @tag.id, :poster_id => current_user.id)
		render :update do |page|
			page.replace_html 'tag_cloud_head', "好友印象"
			page.replace_html 'tag_cloud', :partial => 'tag_cloud'
		end
	end

	def destroy
		Tagging.destroy_all(:tag_id => @tag.id, :taggable_id => @profile.id, :taggable_type => 'Profile')
		render :update do |page|
			page << "$('tag_#{@tag.id}').remove();"
		end
	end

protected

	def setup
		if ["create"].include? params[:action]
			@profile = Profile.find(params[:profile_id])
      @user = @profile.user
			@tag = Tag.find_or_create(:name => params[:tag][:name], :taggable_type => 'Profile')
		elsif ["destroy"].include? params[:action]
			@profile = Profile.find(params[:profile_id])
      @user = @profile.user
			@tag = @profile.tags.find(params[:id])
		end
	rescue
		not_found
	end

	def taggable_required
		@tagging = @profile.taggings.find_by_poster_id(current_user.id)
		@taggable = @user.friends.include?(current_user) && (@tagging.nil? || @tagging.created_at < 1.week.ago)
		@taggable || not_found
	end

end
