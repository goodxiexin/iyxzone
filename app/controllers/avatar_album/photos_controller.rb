class AvatarAlbum::PhotosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :owner_required, :only => [:edit, :set, :update, :destroy]

	before_filter :not_current_avatar_required, :only => [:destroy]

  before_filter :friend_or_owner_required, :only => [:show]

  def show
    @comments = @photo.comments
  end

  def new
    render :action => 'new', :layout => false
  end

  def edit
    render :action => 'edit', :layout => false
  end

  def create
    if @photo = @album.photos.create(params[:photo].merge({:poster_id => current_user.id, :privilege => @album.privilege})) 
			responds_to_parent do
        render :update do |page|
          page << "facebox.close()"
          if params[:album].to_i == 1
            page.redirect_to avatar_album_url(@album)
          else
						@album.reload # i dont know why this is needed
            page.replace_html 'avatar', album_cover(@album, :size => :large)
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

  def set
		Avatar.transaction do 
			@user.update_attribute('avatar_id', @photo.id)
			@album.update_attribute('cover_id', @photo.id)
		end
    flash[:notice] = "修改成功"
    render :update do |page|
      page.redirect_to avatar_album_url(@album)
    end
  end

  def update
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.json { render :json => @photo }
				format.html {
					render :update do |page|
						page << "facebox.close();"
						page << "if($('avatar_notation_#{@photo.id}'))$('avatar_notation_#{@photo.id}').innerHTML = '#{@photo.notation}';"
					end
				}
			end
    else
      flash.now[:error] = "There was an error updating this icon"
      render :action => 'edit'
    end
  end

  def destroy
    @photo.destroy
    flash[:notice] = "删除成功"
    render :update do |page|
      page.redirect_to avatar_album_url(@album)
    end
  end

protected

  def setup
    if ['show', 'edit', 'set', 'update', 'destroy', 'update_notation'].include? params[:action]
      @photo = Avatar.find(params[:id])
      @album = @photo.album
      @user = @album.user
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    elsif ['new', 'create'].include? params[:action]
      @user = current_user
      @album = @user.avatar_album
    end
  rescue
    not_found 
  end

	def not_current_avatar_required
		@user.avatar_id != @photo.id || not_found
	end
	
end

