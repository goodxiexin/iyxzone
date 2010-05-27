class User::ForumsController < UserBaseController

  layout 'app'

  def show
    @forum = Forum.find(params[:id])
    @guild = @forum.guild
    @hot_topics = Topic.hot.nonblocked.match("forum_id != #{@forum.id}").limit(5)
    @top_topics = @forum.topics.top.nonblocked.limit(5)
    @topics = @forum.topics.normal.nonblocked.limit(10) #paginate :page => params[:page], :per_page => PER_PAGE
  end

end
