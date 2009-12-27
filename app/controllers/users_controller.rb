class UsersController < ApplicationController

  def new
    @user = User.new
    @games = Game.find(:all, :order => "pinyin ASC")
    render :action => 'new', :layout => 'root'
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    if User.find_by_email(params[:user][:email])
			render :update do |page|
				page << "$('email_info').innerHTML = '被占用';"
			end
			return
		end
    @user = User.new(params[:user])
    @user.save!
    params[:characters].each do |args|
      @user.characters.create(args)
    end unless params[:characters].blank?
    params[:rating].each do |args|
      Rating.create(args.merge({:rateable_type => 'Game', :user_id => @user.id}))
    end unless params[:rating].blank?
    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before you log in"
    render :update do |page|
      page.redirect_to '/login'
    end
  rescue ActiveRecord::RecordInvalid
    flash.now[:notice] = "There was a problem creating your account"
    render :action => 'new'
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user"
    end
    redirect_to :action => 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user"
    end
    redirect_to :action => 'index'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

	def search
    if !params[:user_key].nil?
      @users = User.search(params[:user_key]).paginate :page => params[:page], :per_page => 16
    elsif !params[:comrade_key].nil?
			@game = Game.find(params[:character][:game_id])
			@area = @game.areas.find(params[:character][:area_id]) unless params[:character][:area_id].blank?
			@server = @game.servers.find(params[:character][:server_id]) unless params[:character][:server_id].blank?
			if !@server.nil?
				@users = @server.users.search(params[:characterkey]).paginate :page => params[:page], :per_page => 16
			elsif !@area.nil?
				@users = @area.users.search(params[:key]).paginate :page => params[:page], :per_page => 16
			else
				@users = @game.users.search(params[:key]).paginate :page => params[:page], :per_page => 16
			end
    elsif !params[:character].nil?
      @users = GameCharacter.search(params[:character][:key], :group => 'user_id').map(&:user).paginate :page => params[:page], :per_page => 16
		end
		render :action => 'search', :layout => 'app'
	end

end
