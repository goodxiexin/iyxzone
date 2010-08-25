class User::MiniBlogsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  def public
    @mini_blogs = MiniBlog.recent.paginate :page => params[:page], :per_page => PER_PAGE    
    @hot_idols = User.match(:is_idol => true).order("fans_count DESC").limit(5).all
    @pop_users = User.match(:is_idol => false).order("friends_count DESC").limit(5).all
   
    # 今日话题和热门话题 
    @meta_data = MiniBlogMetaData.first
    @today_hot_word = @meta_data.today_hot_word
    @today_mini_blogs = MiniBlog.search(@today_hot_word.search_key, :page => 1, :per_page => 50)
    @shuffled_mini_blogs = @today_mini_blogs.shuffle[0..19]
    @start_time, @hot_topics = @meta_data.find_hot_topics
    @hot_topics = @hot_topics[0..9]

    # 引导热词
    @hot_words = HotWord.recent.limit(10)
  end

  def recent
    @mini_blogs = MiniBlog.recent.paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'recent'}}
    render :partial => 'recent_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}
  end

  def hot
    @mini_blogs = MiniBlog.hot.paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'hot'}}
    render :partial => 'hot_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}
  end

  def sexy
    @mini_blogs = MiniBlog.sexy.paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'sexy'}}
    render :partial => 'sexy_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}
  end

  def random
    @mini_blogs = MiniBlog.find(MiniBlogMetaData.first.random_ids).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'sexy'}}
    render :partial => 'sexy_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}
  end

  def same_game
    @fql = current_user.games.map(&:name).join(" ")
    @mini_blogs = MiniBlog.search(@fql, :sort => "created_at DESC", :page => params[:page], :per_page => PER_PAGE)
    render :partial => 'sexy_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}
  end

  def home
    @interested_user_ids = current_user.friend_ids.concat(current_user.idol_ids).concat([current_user.id])
    @mini_blogs = MiniBlog.by(@interested_user_ids).recent.paginate :page => 1, :per_page => PER_PAGE
    @hot_words = HotWord.recent.limit(10) 
    @pop_users = User.match(:is_idol => false).order("friends_count DESC").limit(5)
    @interested_topics = current_user.mini_topic_attentions
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'home_list', :type => params[:type]}} 
  end

  def home_list
    @interested_user_ids = current_user.friend_ids.concat(current_user.idol_ids).concat([current_user.id])
    @mini_blogs = MiniBlog.by(@interested_user_ids).recent.category(params[:type]).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'home_list', :type => params[:type]}} 
    render :partial => 'interested_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}
  end

  def index
    if params[:bid] and params[:reply_to]
      @reply_to = User.find(params[:reply_to])
      @mini_blog = MiniBlog.find(params[:bid])
      @index = @user.mini_blogs.all(:select => "id").map(&:id).index(@mini_blog.id)
    end
    
    @page = @index.nil? ? 1 : @index/PER_PAGE + 1
    @mini_blogs = @user.mini_blogs.paginate :page => @page, :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'index_list', :uid => @user.id, :type => params[:type]}} 
    @interested_idols = @user.idols.order("fans_count DESC").limit(5)
    @interested_topics = @user.mini_topic_attentions
  end

  def index_list
    @mini_blogs = @user.mini_blogs.category(params[:type]).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'index_list', :uid => @user.id, :type => params[:type]}} 
    render :partial => 'personal_mini_blogs', :locals => {:mini_blogs => @mini_blogs, :at => params[:at]}  
  end

  def search
    # construct ferret query lanuage first
    @fql = {}
    @fql[:content] = params[:key] if params[:key]
    @fql[:category] = params[:category] if params[:category] and params[:category] != 'all'
    
    # search index
    @mini_blogs = MiniBlog.search(@fql, :sort => "created_at DESC", :page => params[:page], :per_page => PER_PAGE)
    @idols = User.match(:is_idol => true).all
 
    @meta_data = MiniBlogMetaData.first 
    @start_time, @hot_topics = @meta_data.find_hot_topics
    @hot_topics = @hot_topics[0..9]
  end

  def new
    render :partial => 'form_at_pub', :layout => false
  end

  def create
    @mini_blog = current_user.mini_blogs.build params[:mini_blog]

    if @mini_blog.save
      render :json => {:code => 1, :html => partial_html('interested_mini_blog', :object => @mini_blog.reload, :locals => {:at => params[:at]})}
    else
      render :json => {:code => 0}
    end
  end

  def show
    @user = @mini_blog.poster
    @other_mini_blogs = MiniBlog.by(@user.id).random(:limit => 5, :except => [@mini_blog])
  end

  def new_forward
    @root = @mini_blog.original? ? @mini_blog : @mini_blog.root
    render :action => 'new_forward', :layout => false
  end

  def forward
    @new_mini_blog = current_user.mini_blogs.build :parent_id => @mini_blog.id, :root_id => (@mini_blog.original? ? @mini_blog.id : @mini_blog.root_id), :content => params[:content]

    if @new_mini_blog.save
      render :json => {:code => 1, :html => partial_html('interested_mini_blog', :object => @new_mini_blog.reload, :locals => {:at => params[:at]})}
    else 
      render :json => {:code => 0}
    end
  end

  def destroy
    if @mini_blog.destroy    
      render :json => {:code => 1}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    if ['index', 'index_list'].include? params[:action]
      @user = User.find(params[:uid])
    elsif ['create'].include? params[:action]
      params[:mini_blog][:mini_image] = current_user.mini_images.find(params[:mini_image_id]) unless params[:mini_image_id].blank?
    elsif ['show', 'new_forward', 'forward'].include? params[:action]
      @mini_blog = MiniBlog.find params[:id]
    elsif ['destroy'].include? params[:action]
      @mini_blog = current_user.mini_blogs.find(params[:id])
    end
  end

end
