class User::Events::AlbumsController < UserBaseController

  layout 'app'

  def show
    respond_to do |format|
      format.json {
        @photos = @album.photos
        @json = @photos.map {|p| p.public_filename}
        render :json => @json
      }
      format.html {
        @photos = @album.photos.paginate :page => params[:page], :per_page => 12 
        @participation = @event.participations.find_by_participant_id(current_user.id)
        @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
        render :action => 'show'
      }
    end
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
