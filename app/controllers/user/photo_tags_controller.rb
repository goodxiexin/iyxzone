class User::PhotoTagsController < UserBaseController

  def new
    case params[:type].to_i
    when 0
      @friends = current_user.friends
    when 1
      @friends = current_user.friends.find_all {|f| f.characters.map(&:game_id).include?(params[:game_id].to_i) }
    end
    render :partial => 'friend_table', :locals => {:friends => @friends}
  end

  def create
    @tag = PhotoTag.new((params[:tag] || {}).merge({:poster_id => current_user.id}))
    if @tag.save
			render :text => (@tag.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:poster => {:only => [:login, :id]}, :tagged_user => {:only => [:login, :id]}})
		else
      render :update do |page|
        page << "alert('#{@tag.errors.on_base}');"
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

protected

  def setup
    if ["destroy"].include? params[:action]
      @tag = PhotoTag.find(params[:id])
      require_delete_privilege @tag
    end
  end

  def require_delete_privilege tag
    tag.is_deleteable_by? current_user || render_not_found 
  end

end
