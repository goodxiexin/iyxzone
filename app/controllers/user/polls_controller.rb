class User::PollsController < UserBaseController

  layout 'app'

  def index
    @polls = @user.polls.paginate :page => params[:page], :per_page => 10
  end

	def hot
    @polls = Poll.hot.paginate :page => params[:page], :per_page => 10
	end

  def recent
    @polls = Poll.recent.paginate :page => params[:page], :per_page => 10
	end

  def participated
    @polls = @user.participated_polls.paginate :page => params[:page], :per_page => 10
  end

  def friends
    @polls = current_user.friend_polls.paginate :page => params[:page], :per_page => 10
  end

  def show
		@poll = Poll.find(params[:id])
    @random_polls = Poll.random :limit => 5, :except => [@poll]
    @user = @poll.poster
    @vote = @poll.votes.find_by_voter_id(current_user.id)
    @vote_feeds = current_user.friend_votes_for @poll
    @reply_to = User.find(params[:reply_to]) unless params[:reply_to].blank?
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new((params[:poll] || {}).merge({:poster_id => current_user.id}))
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
    if @poll.update_attributes((params[:poll] || {}).merge({:poster_id => current_user.id}))
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
    elsif ['edit', 'update', 'destroy'].include? params[:action]
      @poll = Poll.find(params[:id])
      require_owner @poll.poster
    end
  end

end
