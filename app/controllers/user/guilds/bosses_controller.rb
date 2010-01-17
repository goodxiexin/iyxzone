class User::Guilds::BossesController < ApplicationController
	
	def new
		@guild = Guild.find(params[:guild_id])
		@boss = Boss.new
		render :partial => "add_boss"
	end

	def edit
		@guild = Guild.find(params[:guild_id])
		render :partial => "edit_bosses"
	end

	def create
		@guild = Guild.find(params[:guild_id])
		@guild.bosses.build(params[:boss])
		if @guild.save
			@guild = Guild.find(params[:guild_id])
			respond_to do |format|
				format.json {render :json => @guild}
				format.html {render :partial => 'boss'}
			end
		end
	end

	def update
		@guild = Guild.find(params[:guild_id])
		if @guild.update_attributes(params[:guild])
			@guild = Guild.find(params[:guild_id])
			respond_to do |format|
				format.json {render :json => @guild}
				format.html {render :partial => 'boss'}
			end
		end
	end

end
