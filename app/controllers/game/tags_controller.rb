class Game::TagsController < ApplicationController

	before_filter :login_required, :setup

	before_filter :taggable_required

	def create
		@tagging.destroy unless @tagging.nil?
    @game.taggings.create(:tag_id => @tag.id, :poster_id => current_user.id)
		render :update do |page|
			page.replace_html 'tag_cloud_head', "玩家印象"
			page.replace_html 'tag_cloud', :partial => 'tag_cloud'
		end
	end

protected

	def setup	
		if ["create"].include? params[:action]
			@game = Game.find(params[:game_id])
			@tag = Tag.find_or_create(:name => params[:tag][:name], :taggable_type => "Game")
		end
	rescue
		not_found		
	end

	def taggable_required
		@tagging = @game.taggings.find_by_poster_id(current_user.id)
		@tagging.nil? || (@tagging.created_at < 1.week.ago) || not_found
	end

end
