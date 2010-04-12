class User::Avatars::PhotosController < UserBaseController

  layout 'app'

  def show
    @relationship = @user.relationship_with current_user
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

  def new
    render :action => 'new', :layout => false
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def create
    @photo = @album.photos.build(params[:photo])
    if @photo.save
			responds_to_parent do
        render :update do |page|
          page << "facebox.close()"
          if params[:at] == 'album'
            page.redirect_to avatar_album_url(@album)
          elsif params[:at] == 'profile'
						@album.reload
            page.replace_html 'avatar', album_cover(@album, :size => :large, :width => 100, :height => 112)
          end
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page << "$('error').innerHTML = 'There was an error uploading this icon"
        end
      end
    end
  end

  def update
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.html { render :update do |page|
					page << "facebox.close();"
          if params[:at] == 'set_cover'
            page.redirect_to avatar_album_url(@album)
          elsif params[:at] == 'photo'
            page.redirect_to avatar_url(@photo)
          end
				end }
				format.json { render :json => @photo }
			end
    else
      respond_to do |format|
        format.html { render :update do |page|
          page << "Iyxzone.enableButton($('edit_photo_submit'), '完成');"
          page.replace_html 'errors', :inline => "<%= error_messages_for :photo, :header_message => '遇到以下问题没法保存', :message => nil %>"
        end }
      end
    end
  end

  def destroy
    if @photo.destroy
      render :update do |page|
        page.redirect_to avatar_album_url(@album)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['show'].include? params[:action]
      @photo = Avatar.find(params[:id])
      @album = @photo.album
      @user = @album.poster
      require_friend_or_owner @user
    elsif ['edit', 'update', 'destroy', 'update_notation'].include? params[:action]
      @album = current_user.avatar_album
      @photo = @album.photos.find(params[:id])
      require_owner @photo.poster
    elsif ['new', 'create'].include? params[:action]
      @album = current_user.avatar_album
    end
  end
	
end

