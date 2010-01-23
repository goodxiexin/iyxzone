class User::TagsController < UserBaseController

  before_filter :deleteable_required, :only => [:destroy]

	def create
    unless @taggable.add_tag current_user, params[:name]
      render :update do |page|
        page << "error('发生错误');"
      end
    end
	end

	def destroy
		if @taggable.destroy_tag @tag.name 
		  render :update do |page|
			  page << "$('tag_#{@tag.id}').remove();"
		  end
    else
      render :update do |page|
        page << "error('发生错误')"
      end
    end
	end

protected

	def setup
    if ["create"].include? params[:action]
      @taggable = get_taggable
		elsif ["destroy"].include? params[:action]
      @taggable = get_taggable
			@tag = Tag.find(params[:id])
		end
	rescue
		not_found
	end

  def deleteable_required
    @taggable.is_tag_deleteable_by?(current_user) || not_found
  end

end
