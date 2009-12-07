class PhotoTagsController < ApplicationController

  before_filter :login_required

  before_filter :catch_photo, :except => [:friends]

  before_filter :catch_tag, :only => [:destroy]

  before_filter :owner_required, :only => [:destroy]

  def create
    if @tag = @photo.tags.create(params[:tag].merge({:poster_id => current_user.id}))
			render :partial => "tag", :object => @tag
		else
      render :update do |page|
        page << "alert('错误，稍后再试');"
      end
    end
  end

  def destroy
    if @tag.destroy
			render :nothing => true
    else
      render :update do |page|
        page << "alert('错误，稍后再试');"
      end
    end
  end

  def friends
    @friends = current_user.friends.find_all {|f| f.login.include? params[:tag][:tagged_user]}
    render :partial => 'friends', :object => @friends
  end

	def all_friends
		@friends = current_user.friends
		render :partial => 'all_friends', :object => @friends
	end
	

protected

  def catch_photo
  end

  def catch_tag
    @tag = @photo.tags.find(params[:id])
  rescue
    not_found
  end

end
