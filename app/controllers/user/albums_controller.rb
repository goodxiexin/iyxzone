class User::AlbumsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  def index
    @relationship = @user.relationship_with current_user
    @privilege = get_privilege_cond @relationship
    @albums = @user.albums.all(:conditions => @privilege).push(@user.avatar_album)
    @albums = @albums.paginate :page => params[:page], :per_page => PER_PAGE
  end

	def recent
    @albums = Album.recent.paginate :page => params[:page], :per_page => PER_PAGE, :include => [{:poster => :profile}, :poster, :cover]
  end

  def friends
    @albums = current_user.friend_albums.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def select
    @albums = current_user.albums
  end

  def show
    respond_to do |format|
      format.html {
        @user = @album.poster
        @photos = @album.photos.paginate :page => params[:page], :per_page => 12 
        @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
        render :action => 'show'
      }
      format.json {
        @photos = @album.photos
        @json = @photos.map {|p| p.public_filename}
        render :json => @json
      }
    end
  end

  def new
    @album = PersonalAlbum.new
    render :action => 'new', :layout => false
  end

  def create
    @album = current_user.albums.build(params[:album] || {})
    
    unless @album.save
      render :update do |page|
        page << "Iyxzone.enableButton($('new_album_submit'),'完成');"
        page.replace_html 'errors', :inline =>"<%= error_messages_for :album, :header_message => '遇到以下问题无法保存', :message => nil %>"
      end
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @album.update_attributes(params[:album] || {})
			respond_to do |format|
        format.html {    
					render :update do |page|
						page << "tip('成功');"
					end
				}
        format.json { render :json => @album }
			end
    else
      respond_to do |format|
        format.html { render :update do |page|
          page << "Iyxzone.enableButton($('edit_album_submit'), '完成');"
          page.replace_html 'errors', :inline => "<%= error_messages_for :album, :header_message => '遇到以下问题无法保存', :message => nil %>"
        end }
      end
    end
  end 

  def confirm_destroy
    render :action => 'confirm_destroy', :layout => false
  end

  def destroy
    if params[:migration] and params[:migration].to_i == 1 and params[:migrate_to]
      new_album = current_user.albums.find(params[:migrate_to])
      Photo.update_all("album_id = #{new_album.id}, privilege = #{new_album.privilege}", {:album_id => @album.id})
      new_album.update_attribute(:photos_count, new_album.photos_count + @album.photos_count)
    end
    
    if @album.destroy
		  render :update do |page|
			  page.redirect_to personal_albums_url(:uid => current_user.id)  
		  end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
	end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ["show"].include? params[:action]
      @album = PersonalAlbum.find(params[:id], :include => [{:comments => [{:poster => :profile}, :commentable]}])
      require_verified @album
      require_adequate_privilege @album
    elsif ["edit", "update", "confirm_destroy", "destroy"].include? params[:action]
      @album = PersonalAlbum.find(params[:id])
      require_verified @album
      require_owner @album.poster
    end
  end

end
