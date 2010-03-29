class User::ForumsController < UserBaseController

  layout 'app'

  def index
    @forums = Forum.all
  end

end
