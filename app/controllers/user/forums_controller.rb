class User::ForumsController < UserBaseController

  def index
    @forums = Forum.all
  end

  def show
    @forum = Forum.find(params[:id])
    redirect_to forum_topics_url(@forum)
  end

end
