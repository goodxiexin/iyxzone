class User::Games::BlogsController < UserBaseController

  def index
    @game = Game.find(params[:game_id])
    @blogs = @game.blogs.nonblocked.for('friend').prefetch([{:poster => :profile}]).paginate :page => params[:page], :per_page => 10
    
    if params[:at] == 'guild_show'
      render :action => 'blogs_list', :layout => false
    else
      render :action => 'index', :layout => 'app'
    end
  end

end
