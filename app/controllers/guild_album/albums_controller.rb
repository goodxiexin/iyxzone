class GuildAlbum::AlbumsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

	before_filter :owner_required, :only => [:update]

  def show
    @membership = @guild.memberships.find_by_user_id(current_user.id)
    @comments = @album.comments
  end

  def update
    if @album.update_attributes(params[:album])
			respond_to do |format|
				format.json { render :json => @album }
			end
    end
  end

protected

  def setup
    @album = GuildAlbum.find(params[:id])
    @guild = @album.guild
    @user = @guild.president
		@reply_to = User.find(params[:reply_to]) if params[:reply_to]
  rescue
    not_found
  end

end
