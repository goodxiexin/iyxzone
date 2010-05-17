class User::TagsController < UserBaseController

	def create
    unless @taggable.add_tag current_user, params[:tag_name]
      render_js_error
    end
	end

	def destroy
    @tag = Tag.find(params[:id])
		
    if @taggable.destroy_tag @tag.name 
			render_js_code "$('tag_#{@tag.id}').remove();"
		else
      render_js_error
    end
	end

  def auto_complete_for_game_tags
    @tags = Tag.game_tags.search(params[:tag][:name])
    render :partial => 'game_tag_list'
  end

protected

	def setup
    if ["create"].include? params[:action]
      @taggable = get_taggable
      require_create_privilege @taggable
		elsif ["destroy"].include? params[:action]
      @taggable = get_taggable
      require_delete_privilege @taggable
		end
	end

  def require_create_privilege taggable
    taggable.is_taggable_by?(current_user) || render_not_found
  end

  def require_delete_privilege taggable
    taggable.is_tag_deleteable_by?(current_user) || render_not_found
  end

end
