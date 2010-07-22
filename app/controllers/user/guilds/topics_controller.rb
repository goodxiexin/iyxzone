class User::Guilds::TopicsController < UserBaseController

  def index
    # 不区分是不是置顶了
    @topics = @forum.topics.nonblocked.limit(20).all
  end

protected

  def setup
    @guild = Guild.find(params[:guild_id])
    @forum = @guild.forum
  end

end
