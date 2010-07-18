class User::MiniBlogsController < UserBaseController

  layout 'app'

  PER_PAGE = 10

  def public
    @mini_blogs = MiniBlog.hot.paginate :page => params[:page], :per_page => PER_PAGE    
    
    # 今日话题
    @meta_data = MiniBlogMetaData.first
    @today_topic_desc = @meta_data.today_topic_desc
    @today_topic = @meta_data.today_topic
    @docs = INDEX.search(@today_topic, :limit => 50)
    @today_mini_blogs = MiniBlog.find(@docs.hits.map{|hit| INDEX.reader.get_document(hit.doc)[:id]})
    @today_mini_blogs = @today_mini_blogs.sort{|a,b| rand(2)<=>rand(2)}[0..19]
    @hot_idols = User.match(:is_idol => true).order("fans_count DESC").limit(5) 
    @pop_users = User.match(:is_idol => false).order("attentions_count DESC").limit(5)
    @hot_topics = MiniTopic.hot.limit(10)
    
    # 我觉得热词和热门话题不太好区分
    @hot_words = MiniTopic.hot.limit(30).all.sort{|a,b| rand(2)<=>rand(2)}[0..9]
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

  def index
    @mini_blogs = @user.mini_blogs.paginate :page => params[:page], :per_page => PER_PAGE
    @hot_topics = MiniTopic.hot.limit(10)
    if @user == current_user
      @hot_idols = User.match(:is_idol => true).order("fans_count DESC").limit(5) 
    else
      @interested_idols = @user.idols.order("fans_count DESC").limit(5)
    end
  end

  def list
    @mini_blogs = @user.mini_blogs.category(params[:type]).paginate :page => params[:page], :per_page => PER_PAGE
    @remote = {:update => 'mini_blogs_list', :url => {:action => 'list', :type => params[:type]}} 
    render :partial => 'personal_mini_blogs', :locals => {:mini_blogs => @mini_blogs}
  end

  def interested
    @mini_blogs = current_user.interested_mini_blogs.paginate :page => params[:page], :per_page => PER_PAGE
    @interested_idols = current_user.idols.order("fans_count DESC").limit(5) 
  end

  def search
    page = params[:page].nil? ? 1 : params[:page].to_i
    @docs = INDEX.search(params[:key], :offset => (page - 1) * PER_PAGE, :limit => PER_PAGE)
    @mini_blogs = MiniBlog.find(@docs.hits.map{|hit| INDEX.reader.get_document(hit.doc)[:id]})
    @mini_blogs = WillPaginate::Collection.create(page, PER_PAGE, @docs.total_hits) {|pager| pager.replace @mini_blogs.to_a}
    @idols = User.match(:is_idol => true).all
    @hot_topics = MiniTopic.hot.limit(10)
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
    if ['index', 'list'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['create'].include? params[:action]
      params[:mini_blog][:mini_image] = current_user.mini_images.find(params[:mini_image_id]) unless params[:mini_image_id].blank?
    elsif ['new_forward', 'forward'].include? params[:action]
      @mini_blog = MiniBlog.find params[:id]
    elsif ['destroy'].include? params[:action]
      @mini_blog = current_user.mini_blogs.find(params[:id])
    end
  end

end
