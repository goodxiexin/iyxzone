class User::SharingsController < UserBaseController

  layout 'app'

  PER_PAGE = 5 

  def index
    if params[:type].to_i == 0 and !params[:sharing_id].blank? and !params[:sharing_id].blank?
      @reply_to = User.find(params[:reply_to])
      @sharing = Sharing.find(params[:sharing_id])
      params[:page] = current_user.sharings.index(@sharing) / PER_PAGE + 1
    end

    case params[:type].to_i
    when 0
      @sharings = @user.sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 1
      @sharings = @user.blog_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 2
      @sharings = @user.video_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 3
      @sharings = @user.link_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 4
      @sharings = @user.photo_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 5
      @sharings = @user.album_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 6
      @sharings = @user.poll_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 7
      @sharings = @user.game_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 8
      @sharings = @user.profile_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def hot
    case params[:type].to_i
    when 0
      @sharings = Sharing.hot.paginate :page => params[:page], :per_page => PER_PAGE
    when 1
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Blog'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 2
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Video'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 3
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Link'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 4
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Photo'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 5
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Album'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 6
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Poll'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 7
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Game'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 8
      @sharings = Sharing.hot.find(:all, :conditions => {:shareable_type => 'Profile'}).paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def recent
    case params[:type].to_i
    when 0
      @sharings = Sharing.recent.paginate :page => params[:page], :per_page => PER_PAGE
    when 1
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Blog'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 2
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Video'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 3
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Link'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 4
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Photo'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 5
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Album'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 6
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Poll'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 7
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Game'}).paginate :page => params[:page], :per_page => PER_PAGE
    when 8
      @sharings = Sharing.recent.find(:all, :conditions => {:shareable_type => 'Profile'}).paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def friends
    case params[:type].to_i
    when 0
      @sharings = current_user.friend_sharings.paginate :page => params[:page], :per_page => PER_PAGE
    when 1
      @sharings = current_user.friend_sharings('Blog').paginate :page => params[:page], :per_page => PER_PAGE
    when 2
      @sharings = current_user.friend_sharings('Video').paginate :page => params[:page], :per_page => PER_PAGE
    when 3
      @sharings = current_user.friend_sharings('Link').paginate :page => params[:page], :per_page => PER_PAGE
    when 4
      @sharings = current_user.friend_sharings('Photo').paginate :page => params[:page], :per_page => PER_PAGE
    when 5
      @sharings = current_user.friend_sharings('Album').paginate :page => params[:page], :per_page => PER_PAGE
    when 6
      @sharings = current_user.friend_sharings('Poll').paginate :page => params[:page], :per_page => PER_PAGE
    when 7
      @sharings = current_user.friend_sharings('Game').paginate :page => params[:page], :per_page => PER_PAGE
    when 7
      @sharings = current_user.friend_sharings('Profile').paginate :page => params[:page], :per_page => PER_PAGE
    end
  end

  def new
    if params[:link].blank?
      @shareable = params[:shareable_type].camelize.constantize.find(params[:shareable_id])
      @title = @shareable.default_share_title
    else
      @title = params[:link]
    end

    if params[:outside].nil?
      render :action => 'new', :layout => false
    else
      render :action => 'new_from_outside', :layout => false
    end
  end

  def create
    sharing_params = (params[:sharing] || {}).merge({:poster_id => current_user.id})
    @sharing = Sharing.new(sharing_params)
    
    if @sharing.save
      render :update do |page|
        if @sharing.shareable_type == 'Link'
          if params[:outside]
            page << "window.close();"
          else
            page.redirect_to sharings_url(:uid => current_user.id)
          end
        else
          page << "notice('分享成功');"
        end
      end
    else
      render :update do |page|
        page << "tip('你已经分享过这个资源了');"
      end
    end
  end

  # show only works for link
  # for blog,video, photo, album, the page will be reidrected to blog_url, video_url... etc
  def show
    render :action => 'show', :layout => false
  end

protected

  def setup
    if ["index"].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif["show"].include? params[:action]
      @sharing = Sharing.find(params[:id])
      require_link_sharing @sharing
      @shareable = @sharing.shareable
    end
  end

  def require_link_sharing sharing
    sharing.shareable_type == 'Link' || render_not_found
  end

end
