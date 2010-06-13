class User::Events::AlbumsController < UserBaseController

  layout 'app'

  def show
    respond_to do |format|
      format.html {
        @photos = @album.photos.nonblocked.paginate :page => params[:page], :per_page => 12 
        @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
        render :action => 'show'
      }
      format.json {
        render :json => @album.photos.nonblocked.map{|p| p.public_filename}
      }
    end
  end

	def update
		if @album.update_attributes(params[:album])
			respond_to do |format|
				format.json { render :json => @album }
			end
		else
      render_js_error
    end
	end

protected

  def setup
		@album = EventAlbum.find(params[:id], :include => [{:comments => [{:poster => :profile}, :commentable]}])
    require_verified @album
    @event = @album.event
		@user = @event.poster
    require_owner @user if params[:action] == 'update'
  end

end
