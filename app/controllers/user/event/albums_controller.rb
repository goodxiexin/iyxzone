class User::Event::AlbumsController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  def show
    @participation = @event.participations.find_by_participant_id(current_user.id)
    @comments = @album.comments
  end

	def update
		if @album.update_attributes(params[:event_album])
			respond_to do |format|
				format.json { render :json => @album }
			end
		else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
	end

protected

  def setup
		@album = EventAlbum.find(params[:id])
    @event = @album.event
		@user = @event.poster
		@reply_to = User.find(params[:reply_to]) if params[:reply_to]
  rescue
    not_found
  end

end
