class User::Games::AlbumsController < UserBaseController

  def index
    @game = Game.find(params[:game_id])
    @per_page = (params[:at] == 'guild_show')? 12 : 10
    @albums = @game.albums.nonblocked.for('friend').paginate :page => params[:page], :per_page => @per_page, :include => [{:poster => :profile}, :cover, :latest_photos]
    
    if params[:at] == 'guild_show'
      render :action => 'albums_list', :layout => false
    else
      render :action => 'index', :layout => 'app'
    end
  end

end
