class User::Guilds::GearsController < ApplicationController
	def new
		@guild = Guild.find(params[:guild_id])
		@gear = Gear.new
		render :partial => "add_gear"
	end

	def edit
		@guild = Guild.find(params[:guild_id])
		render :partial => "edit_gears"
	end

	def create
		@guild = Guild.find(params[:guild_id])
		@guild.gears.build(params[:gear])
		if @guild.save
			@guild = Guild.find(params[:guild_id])
			respond_to do |format|
				format.json {render :json => @guild}
				format.html {render :partial => 'gear'}
			end
		end
	end

	def update
		@guild = Guild.find(params[:guild_id])
		if @guild.update_attributes(params[:guild])
			@guild = Guild.find(params[:guild_id])
			respond_to do |format|
				format.json {render :json => @guild}
				format.html {render :partial => 'gear'}
			end
		end
	end
end
