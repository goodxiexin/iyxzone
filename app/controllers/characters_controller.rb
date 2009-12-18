class CharactersController < ApplicationController

	before_filter :login_required, :setup

	before_filter :owner_required, :only => [:edit, :update]

	def new
    @games = Game.find(:all, :order => 'pinyin ASC')
	end
	
	def create
		@game.create_rating(:rating => params[:game_rate], :user_id => current_user.id)
		@character = current_user.characters.build(params[:character])
		if @character.save
			render :partial => 'character', :collection => current_user.characters
		else
			render :action => 'new'
		end
	end

	def edit
    @games = Game.find(:all, :order => 'pinyin ASC')
    @game = @character.game
	end

	def update
		@game.create_rating(:user_id => current_user.id, :rating => params[:game_rate])
		if @character.update_attributes(params[:character])
			render :partial => 'character', :collection => current_user.characters
		else
			render :action => 'edit'
		end
	end

protected

	def setup
		if ["new"].include? params[:action]
		elsif ["create"].include? params[:action]
			@game = Game.find(params[:character][:game_id])
		elsif ["edit"].include? params[:action]
			@character = current_user.characters.find(params[:id])
      @user = @character.user
		elsif ["update"].include? params[:action]
			@character = current_user.characters.find(params[:id])
			@user = @character.user
			@game = Game.find(params[:character][:game_id])
		end
	rescue
		not_found
	end

end
