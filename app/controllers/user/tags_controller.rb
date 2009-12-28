class User::TagsController < ApplicationController

	before_filter :login_required, :setup

	def create
		@tagging.destroy unless @tagging.nil?
		@taggable.taggings.create(:tag_id => @tag.id, :poster_id => current_user.id)
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
      @taggable = get_taggable
      can_create?
			@tag = Tag.find_or_create(:name => params[:tag][:name], :taggable_type => @taggable.class.name)
		elsif ["destroy"].include? params[:action]
			@tag = Tag.find(params[:id])
		end
	rescue
		not_found
	end

end
