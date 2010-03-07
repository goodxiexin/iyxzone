class User::AlbumsController < UserBaseController

  layout 'app'

  def index
    @relationship = @user.relationship_with current_user
    @albums = @user.albums.viewable(@relationship).push(@user.avatar_album).paginate :page => params[:page], :per_page => 10
  end

	def recent
    @albums = PersonalAlbum.recent.paginate :page => params[:page], :per_page => 5
  end

  def friends
    @albums = current_user.personal_album_feed_items.map(&:originator).uniq.paginate :page => params[:page], :per_page => 10 
  end

  def select
    @albums = current_user.albums
  end

  def show
    @user = @album.poster
    @photos = @album.photos.paginate :page => params[:page], :per_page => 12 
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def new
    @album = PersonalAlbum.new
    render :action => 'new', :layout => false
  end

  def create
    @album = current_user.albums.build(params[:album] || {})
    
    unless @album.save
      render :update do |page|
        page.replace_html 'errors', :partial => 'validation_errors'
      end
    end
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    if @album.update_attributes((params[:album] || {}).merge({:owner_id => current_user.id}))
			respond_to do |format|
        format.json { render :text => @album.description }
        format.html {    
					render :update do |page|
						page.alert '成功'
					end
				}
			end
    else
      render :update do |page|
        page.replace_html 'errors', :partial => 'validation_errors'
      end
    end
  end 

  def confirm_destroy
    render :action => 'confirm_destroy', :layout => false
  end

  def destroy
    if params[:migration] and params[:migration].to_i == 1 and !params[:album][:id].blank?
      Photo.update_all("album_id = #{params[:album][:id]}", "album_id = #{@album.id}")
      Album.update_all("photos_count = photos_count + #{@album.photos_count}", "id = #{params[:album][:id]}")
    end

    if @album.destroy
		  render :update do |page|
			  page.redirect_to personal_albums_url(:id => current_user.id)  
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
    elsif ["recent"].include? params[:action]
      @user = User.find(params[:uid])
    elsif ["show"].include? params[:action]
      @album = PersonalAlbum.find(params[:id])
      require_adequate_privilege @album
    elsif ["edit", "update", "confirm_destroy", "destroy"].include? params[:action]
      @album = PersonalAlbum.find(params[:id])
      require_owner @album.poster
    end
  end

end
