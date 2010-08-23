class User::PhotoTagsController < UserBaseController

  def create
    @tag = @photo.tags.build((params[:tag] || {}).merge({:poster_id => current_user.id}))
    
    if @tag.save
      render :json => {:code => 1, :tag => {:id => @tag.id, :x => @tag.x, :y => @tag.y, :width => @tag.width, :height => @tag.height, :content => @tag.content, :tagged_user => {:id => @tag.tagged_user_id, :login => @tag.tagged_user.login}, :poster => {:id => @tag.poster_id, :login => @tag.poster.login}}}
		else
      render :json => {:code => 0}
    end
  end

  def destroy
    if @tag.destroy
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ["create"].include? params[:action]
      @photo = params[:photo_type].camelize.constantize.find(params[:photo_id])
    elsif ["destroy"].include? params[:action]
      @tag = PhotoTag.find(params[:id])
      require_verified @tag.photo
      require_delete_privilege @tag
    end
  end

  def require_delete_privilege tag
    tag.is_deleteable_by? current_user || render_not_found 
  end

end
