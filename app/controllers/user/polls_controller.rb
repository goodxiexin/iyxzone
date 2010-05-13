class User::PollsController < UserBaseController

  layout 'app'

  PER_PAGE = 10
  PREFETCH = [{:poster => :profile}, :answers]

  def index
    @polls = @user.polls.nonblocked.prefetch(PREFETCH).paginate :page => params[:page], :per_page => PER_PAGE
  end

	def hot
    @polls = Poll.hot.nonblocked.prefetch(PREFETCH).paginate :page => params[:page], :per_page => PER_PAGE
	end

  def recent
    @polls = Poll.recent.nonblocked.prefetch(PREFETCH).paginate :page => params[:page], :per_page => PER_PAGE
	end

  def participated
    @polls = @user.participated_polls.nonblocked.prefetch(PREFETCH).paginate :page => params[:page], :per_page => PER_PAGE
  end

  def friends
    # polls that your friends participated in
    @participated = Poll.nonblocked.prefetch(PREFETCH).find(Vote.by(current_user.friend_ids).map(&:poll_id).uniq)
    # polls that your friend posted
    @posted = Poll.by(current_user.friend_ids).nonblocked.prefetch(PREFETCH)
    @polls = (@participated + @posted).uniq.sort{|p1,p2| p1.created_at <=> p2.created_at}.paginate :page => params[:page], :per_page => PER_PAGE
  end

  def show
    @random_polls = Poll.random :limit => 5, :except => [@poll]
    @user = @poll.poster
    @vote = @poll.votes.find_by_voter_id(current_user.id)
    @vote_feeds = @poll.votes.by(current_user.friend_ids)#current_user.friend_votes_for @poll
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = current_user.polls.build(params[:poll] || {})

    if @poll.save
      redirect_to poll_url(@poll)
    else
      render :action => 'new'
    end
  end

  def edit
    if params[:type].to_i == 0
      render :action => 'edit_deadline', :layout => false
    elsif params[:type].to_i == 1
      render :action => 'edit_explanation', :layout => false
    end
  end

  def update
    if @poll.update_attributes(params[:poll] || {})
      render :update do |page|
        page << "facebox.close();"
      end
    else
      render :update do |page|
        page.replace_html 'errors', :inline => "<%= error_messages_for :poll, :header_message => '遇到以下问题没法保存', :message => nil %>"
      end
    end 
  end

  def destroy
    if @poll.destroy
      render :update do |page|
        page << "facebox.close();"
        page.redirect_to polls_url(:uid => current_user.id)
      end
    else
      render :update do |page|
        page << "error('发生错误');"
      end
    end
  end

protected

  def setup
    if ['index', 'participated'].include? params[:action]
      @user = User.find(params[:uid])
      require_friend_or_owner @user
    elsif ['show'].include? params[:action]
      @poll = Poll.find(params[:id], :include => [{:poster => :profile}, :votes, {:comments => [{:poster => :profile}, :commentable]}])
      require_verified @poll
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @poll = Poll.find(params[:id])
      require_verified @poll
      require_owner @poll.poster
    end
  end

end
