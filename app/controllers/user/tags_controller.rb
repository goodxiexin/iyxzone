class User::TagsController < UserBaseController

  def index
    respond_to do |format|
      format.html { render :partial => 'tag_cloud', :locals => {:taggable => @taggable, :deleteable => @taggable.is_tag_deleteable_by?(current_user)}}
      format.json { render :json => @taggable.tags.map{|t| {:id => t.id, :name => t.name}} }
    end
  end

	def create
    if @taggable.add_tag current_user, params[:tag_name]
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
	end

	def destroy
    @tag = Tag.find(params[:id])
		
    if @taggable.destroy_tag @tag.name 
			render :json => {:code => 1}
		else
      render :json => {:code => 0}
    end
	end

  def auto_complete_for_game_tags
    @tags = Tag.game_tags.search(params[:tag][:name])
    render :partial => 'game_tag_list'
  end

protected

	def setup
    if ["index", "create"].include? params[:action]
      @taggable = params[:taggable_type].camelize.constantize.find(params[:taggable_id])
      require_create_privilege @taggable if params[:action] == 'create'
		elsif ["destroy"].include? params[:action]
      # 不是真的删除tag，只是删除taggable关于这个tag的所有taggings
      @taggable = params[:taggable_type].camelize.constantize.find(params[:taggable_id])
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
