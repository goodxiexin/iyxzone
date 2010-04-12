class User::PhotosController < UserBaseController

  layout 'app'

	def hot
    @photos = Photo.hot.paginate :page => params[:page], :per_page => 10
  end

  def relative
    @infos = []
    @user.photo_tags.group_by(&:photo_id).map do |photo_id, tags|
      photo = Photo.find(photo_id)
      if !photo.is_owner_privilege?
        @infos << {:photo => photo, :posters => tags.map(&:poster).uniq}
      end
    end
    @infos = @infos.paginate :page => params[:page], :per_page => 12
  end

  def new
  end

  def show
    @user = @photo.poster
    @relationship = @user.relationship_with current_user
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
    @tags = @photo.tags.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:tagged_user => {:only => [:login, :id]}, :poster => {:only => [:login, :id]}}
  end

	def create
    @photo = @album.photos.build(:swf_uploaded_data => params[:Filedata])
    
    if @photo.save
			render :text => @photo.id	
		end
	end

  def record_upload
    @photos = @album.photos.find(params[:ids] || [])
		@album.record_upload current_user, @photos
    render :update do |page|
      page.redirect_to edit_multiple_personal_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
    end
  end 

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.html { render :update do |page|
          if params[:at] == 'album'
					  if @album.id != @photo.album_id
						  page.redirect_to personal_album_url(@album)
					  else
						  page << "facebox.close();"
            end
          elsif params[:at] == 'photo'
            page << "facebox.close();"
#						page << "$('personal_photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation.gsub(/\n/, '<br/>')}';"
						page << "$('personal_photo_notation_#{@photo.id}').update(     '#{@photo.notation.gsub(/\n/, '<br/>')}');"

					end
				end }
				format.json { render :json => @photo }
			end 
    else
      respond_to do |format|
        format.html { render :update do |page|
          page << "Iyxzone.enableButton($('edit_photo_submit'), '完成');"
          page.replace_html 'errors', :inline => "<%= error_messages_for :photo, :header_message => '遇到以下问题无法保存', :message => nil %>"
        end }
      end
    end
  end

  def edit_multiple
    @photos = @album.photos.find(params[:ids] || [])
  end

  def update_multiple
    params[:photos].each do |id, attributes|
      photo = @album.photos.find(id)
      photo.update_attributes(attributes)
    end
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    redirect_to personal_album_url(@album) 
  end

  def destroy
    if @photo.destroy
      render :update do |page|
        page.redirect_to personal_album_url(@album)
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
      @photo = PersonalPhoto.find(params[:id])
      @album = @photo.album
      require_adequate_privilege @album
    elsif ['new', 'create', 'record_upload', 'edit_multiple', 'update_multiple'].include? params[:action]
      @album = PersonalAlbum.find(params[:album_id])
      require_owner @album.poster
		elsif ['hot'].include? params[:action]
      @user = User.find(params[:uid])
    elsif ['relative'].include? params[:action]
			@user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @photo = PersonalPhoto.find(params[:id])
      @album = @photo.album
      require_owner @album.poster
    end
  end

end
