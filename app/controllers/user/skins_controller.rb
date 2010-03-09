class User::SkinsController < UserBaseController
  layout 'app2'

  #increment_viewing 'profile', :only => [:show]

	FirstFetchSize = 5

	FetchSize = 5

  def show
		@user = current_user
		@blogs = @user.blogs[0..2]
		@albums = @user.active_albums[0..2]
    @setting = @user.privacy_setting
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
		#@feed_deliveries = @profile.feed_deliveries.find(:all, :limit => FirstFetchSize, :order => 'created_at DESC')
		@first_fetch_size = FirstFetchSize
		
		#render 'profiles/show'
	end

	def index
	end


protected

  def setup
  end


end
