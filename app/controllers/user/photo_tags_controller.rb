class User::PhotoTagsController < UserBaseController

  def create
    @tag = PhotoTag.new((params[:tag] || {}).merge({:poster_id => current_user.id}))
    if @tag.save
			render :text => (@tag.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:poster => {:only => [:login, :id]}, :tagged_user => {:only => [:login, :id]}})
		else
      render_js_error @tag.errors.on(:photo_id)
    end
  end

  def destroy
    if @tag.destroy
			render :update do |page|
        page << "facebox.close();"
      end
    else
      render_js_error
    end
  end

protected

  def setup
    if ["destroy"].include? params[:action]
      @tag = PhotoTag.find(params[:id])
      require_verified @tag.photo
      require_delete_privilege @tag
    end
  end

  def require_delete_privilege tag
    tag.is_deleteable_by? current_user || render_not_found 
  end

end
