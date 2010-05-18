class User::Guilds::EventsController < UserBaseController

  layout 'app'

  def index
    @events = @guild.events.nonblocked.paginate :page => params[:page], :per_page => 10, :include => [{:poster => :profile}, {:album => :cover}, {:game_server => [:area, :game]}]
  end

protected

  def setup
    @guild = Guild.find(params[:guild_id])
    require_verified @guild
  end

end
