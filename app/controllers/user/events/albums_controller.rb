class User::Events::AlbumsController < UserBaseController

  layout 'app'

  def show
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @participation = @event.participations.find_by_participant_id(current_user.id)
    @photos = @album.photos.paginate :page => params[:page], :per_page => 12
  end

	def update
		if @album.update_attributes((params[:album] || {}).merge({:owner_id => @event.id}))
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
    require_owner @user if params[:action] == 'update'
  end

end
