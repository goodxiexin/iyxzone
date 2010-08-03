require 'ferret'
class User::MiniBlogsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  def public
    @mini_blogs = MiniBlog.hot.paginate :page => params[:page], :per_page => PER_PAGE    
    
    # 今日话题
    @meta_data = MiniBlogMetaData.first
    @today_topic_desc = @meta_data.today_topic_desc
    @today_topic = @meta_data.today_topic
    @today_mini_blogs = MiniBlog.search(@today_topic, :page => 1, :per_page => 50)
    @shuffled_mini_blogs = @today_mini_blogs.shuffle[0..19]

    @hot_idols = User.match(:is_idol => true).order("fans_count DESC").limit(5) 

    @pop_users = User.match(:is_idol => false).order("friends_count DESC").limit(5)

    # 6小时内的最热话题
    @start_time, @topics = MiniTopic.hot
    @hot_topics = @topics[0..9]

    # 引导热词
    @hot_words = HotWord.recent.limit(10)
  end

  def hot
    @mini_blogs = MiniBlog.hot.paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'hot'}}
    render :partial => 'hot_mini_blogs', :locals => {:mini_blogs => @mini_blogs}
  end

  def sexy
    @mini_blogs = MiniBlog.sexy.paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'sexy'}}
    render :partial => 'sexy_mini_blogs', :locals => {:mini_blogs => @mini_blogs}
  end

  def random
    @mini_blogs = MiniBlog.find(MiniBlogMetaData.first.random_ids).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'sexy'}}
    render :partial => 'sexy_mini_blogs', :locals => {:mini_blogs => @mini_blogs}
  end

  def same_game
    @fql = current_user.games.map(&:name).join(" OR ")
    @mini_blogs = MiniBlog.search(@fql, :sort => "created_at DESC", :page => params[:page], :per_page => PER_PAGE)
    render :partial => 'sexy_mini_blogs', :locals => {:mini_blogs => @mini_blogs}
  end

  def home
    @interested_user_ids = current_user.friend_ids.concat(current_user.idol_ids).concat([current_user.id])
    @mini_blogs = MiniBlog.by(@interested_user_ids).paginate :page => 1, :per_page => PER_PAGE
    @hot_words = HotWord.recent.limit(10) 
    @pop_users = User.match(:is_idol => false).order("friends_count DESC").limit(5)
    @interested_topics = current_user.mini_topic_attentions
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'home_list', :type => params[:type]}} 
  end

  def home_list
    @interested_user_ids = current_user.friend_ids.concat(current_user.idol_ids).concat([current_user.id])
    @mini_blogs = MiniBlog.by(@interested_user_ids).category(params[:type]).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'home_list', :type => params[:type]}} 
    render :partial => 'personal_mini_blogs', :locals => {:mini_blogs => @mini_blogs}
  end

  def index
    @mini_blogs = @user.mini_blogs.paginate :page => 1, :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'index_list', :type => params[:type]}} 
    @interested_idols = @user.idols.order("fans_count DESC").limit(5)
    @interested_topics = @user.mini_topic_attentions
  end

  def index_list
    @mini_blogs = @user.mini_blogs.category(params[:type]).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'index_list', :type => params[:type]}} 
    render :partial => 'personal_mini_blogs', :locals => {:mini_blogs => @mini_blogs}  
  end

  def search
    # construct ferret query lanuage first
    @fql = []
    if params[:key]
      @fql << "content:(#{params[:key].split(/\s*~\s*/).map{|a| "(#{a.split(/\s+/).join(" AND ")})"}.join(" OR ")})"
    end
    if params[:category] and params[:category] != 'all'
      @fql << "category:(#{params[:category]})"
    end
    @fql = @fql.join(" AND ")

    # search index
    @mini_blogs = MiniBlog.search(@fql, :sort => "created_at DESC", :page => params[:page], :per_page => PER_PAGE)
    @idols = User.match(:is_idol => true).all
    @time, @hot_topics = MiniTopic.hot
    @hot_topics = @hot_topics[0..9]
  end

  def new
    render :partial => 'form_at_pub', :layout => false
  end

  def create
    @mini_blog = current_user.mini_blogs.build params[:mini_blog]

    unless @mini_blog.save
      render_js_error
    end
  end

  def new_forward
    @root = @mini_blog.original? ? @mini_blog : @mini_blog.root
    render :action => 'new_forward', :layout => false
  end

  def forward
    @new_mini_blog = @mini_blog.forward current_user, params[:content]

    if @new_mini_blog.id.nil?
      render_js_error
    end
  end

  def destroy
    if @mini_blog.destroy    
      render_js_code "Effect.BlindUp($('mini_blog_#{@mini_blog.id}'));"
    else
      render_js_error
    end
  end

protected

  def setup
    if ['index', 'index_list'].include? params[:action]
      @user = User.find(params[:uid])
    elsif ['create'].include? params[:action]
      params[:mini_blog][:mini_image] = current_user.mini_images.find(params[:mini_image_id]) unless params[:mini_image_id].blank?
    elsif ['new_forward', 'forward'].include? params[:action]
      @mini_blog = MiniBlog.find params[:id]
    elsif ['destroy'].include? params[:action]
      @mini_blog = current_user.mini_blogs.find(params[:id])
    end
  end

end
