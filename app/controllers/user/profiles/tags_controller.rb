class User::Profiles::TagsController < User::TagsController

  before_filter :login_required, :setup

  before_filter :taggable_required, :only => [:create]

  def create
    @tagging.destroy unless @tagging.nil?
    @profile.taggings.create(:tag_id => @tag.id, :poster_id => current_user.id)
  end

  def destroy
    Tagging.destroy_all(:tag_id => @tag.id, :taggable_id => @profile.id, :taggable_type => 'Profile')
    render :update do |page|
      page << "$('tag_#{@tag.id}').remove();"
    end
  end

protected

  def setup
    if ["create"].include? params[:action]
      @profile = Profile.find(params[:profile_id])
      @tagging = @profile.taggings.find_by_poster_id(current_user.id)
      @user = @profile.user
      @tag = Tag.find_or_create(:name => params[:tag][:name], :taggable_type => "Profile")
    elsif ["destroy"].include? params[:action]
      @tag = Tag.find(params[:id])
    end
  rescue
    not_found
  end

  def taggable_required
    @tagging = @profile.taggings.find_by_poster_id(current_user.id)
    @taggable = @user.friends.include?(current_user) && (@tagging.nil? || @tagging.created_at < 1.week.ago)
    @taggable || not_found
  end

end
