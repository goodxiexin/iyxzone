class PersonalAlbum::PhotosController < ApplicationController

  layout 'app'

  before_filter :login_required, :setup

  before_filter :privilege_required, :only => [:show]

  before_filter :owner_required, :only => [:new, :create, :edit, :update, :destroy, :edit_multiple, :update_multiple, :record_upload]

	before_filter :friend_or_owner_required, :only => [:relative]

	def hot
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @photos = Photo.hot.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

  def relative
		cond = params[:game_id].nil? ? {} : {:game_id => params[:game_id]}
    @photos = @user.relative_photos.find(:all, :conditions => cond).paginate :page => params[:page], :per_page => 10
  end

  def new
  end

  def show
    @comments = @photo.comments
  end

	def create
		if @photo = @album.photos.create(:poster_id => current_user.id, :game_id => @album.game_id, :privilege => @album.privilege, :swf_uploaded_data => params[:Filedata])
			render :text => @photo.id	
		else
			# TODO
		end
	end

  def record_upload
		if @album.record_upload current_user, @photos
      render :update do |page|
        page.redirect_to edit_multiple_personal_photos_url(:album_id => @album.id, :ids => @photos.map {|p| p.id})
      end
    end
  end 

  def edit
    render :action => 'edit', :layout => false
  end

  def update
    @album.update_attribute('cover_id', @photo.id) if params[:cover]
    if @photo.update_attributes(params[:photo])
			respond_to do |format|
				format.json { render :json => @photo }
				format.html {
					render :update do |page|
						if @photo.album_id_changed?
						  page.redirect_to personal_photo_url(@photo)
						else
						  page << "facebox.close();"
							page << "if($('personal_photo_notation_#{@photo.id}'))$('personal_photo_notation_#{@photo.id}').innerHTML = '#{@photo.notation}';"
						end
					end
				}
			end 
    else
      # TODO
    end
  end

  def edit_multiple
  end

  def update_multiple
    @album.update_attribute('cover_id', params[:cover_id]) if params[:cover_id]
    @photos.each {|photo| photo.update_attributes(params[:photos]["#{photo.id}"]) }
    redirect_to personal_album_url(@album) 
  end

  def destroy
    @photo.destroy
    render :update do |page|
      page.redirect_to personal_album_url(@album)
    end
  end

protected

  def setup
    if ['show', 'edit', 'update', 'destroy'].include? params[:action]
      @photo = PersonalPhoto.find(params[:id])
      @album = @photo.album
      @user = @album.user
			@privilege = @album.privilege
			@reply_to = User.find(params[:reply_to]) if params[:reply_to]
    elsif ['new', 'create'].include? params[:action]
      @user = current_user
      @album = PersonalAlbum.find(params[:album_id])
    elsif ['record_upload', 'edit_multiple'].include? params[:action]
      @user = current_user
      @album = PersonalAlbum.find(params[:album_id])
      @photos = params[:ids].blank? ? [] : @album.photos.find(params[:ids])
    elsif ['update_multiple'].include? params[:action]
      @user = current_user
      @album = PersonalAlbum.find(params[:album_id])
      @photos = params[:photos].blank? ? [] : @album.photos.find(params[:photos].map {|id, attribute| id})
		elsif ['hot', 'relative'].include? params[:action]
			@user = User.find(params[:id])
    end
  end
end
