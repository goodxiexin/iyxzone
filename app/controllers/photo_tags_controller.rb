class PhotoTagsController < ApplicationController

  before_filter :login_required

  before_filter :catch_photo, :except => [:friends]

  before_filter :catch_tag, :only => [:destroy]

  before_filter :owner_required, :only => [:destroy]

  def index
    render :json => @photo.tags
  end

  def create
    if @tag = @photo.tags.create(params[:tag].merge({:poster_id => current_user.id}))
			render :text => (@tag.to_json :only => [:id, :width, :height, :x, :y, :content], :include => {:poster => {:only => [:login, :id]}, :tagged_user => {:only => [:login, :id]}})
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

  def auto_complete_for_friends
    @friends = current_user.friends.find_all {|f| f.pinyin.starts_with? params[:friend][:login]}
    render :partial => 'auto_complete_friends', :object => @friends
  end

  def friends
    case params[:type].to_i
    when 0
      @friends = current_user.friends
    when 1
      @friends = current_user.friends.find_all {|f| f.characters.map(&:game_id).include?(params[:game_id].to_i) }
    end
    render :partial => 'friends', :object => @friends
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
