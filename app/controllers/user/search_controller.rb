class User::SearchController < UserBaseController

  layout 'app'

  PER_PAGE = 20

  def user
    @key = params[:key]
    @games = Game.find(:all, :order => 'pinyin ASC')
    @users = User.activated.search(@key).paginate :page => params[:page], :per_page => PER_PAGE, :include => [:profile, {:characters => [{:server => [:area, :game]}]}] 
  end

  def character
    @game = Game.find(params[:game_id]) unless params[:game_id].blank?
    @area = @game.areas.find(params[:area_id]) unless params[:area_id].blank?
    @server = @game.servers.find(params[:server_id]) unless params[:server_id].blank?

    cond = {}
    cond.merge!({:game_id => @game.id}) if !@game.nil? 
    cond.merge!({:area_id => @area.id}) if !@area.nil?
    cond.merge!({:server_id => @server.id}) if !@server.nil?
    
    if @game.nil?
      @areas = []
      @servers = []
    elsif !@game.nil? and !@game.no_areas
      @areas = @game.areas
      @servers = @area.nil? ? [] : @area.servers
    elsif !@game.nil? and @game.no_areas
      @areas = []
      @servers = @game.servers
    end

    @key = params[:key]
    @games = Game.find(:all, :order => 'pinyin ASC')
		@total_users = GameCharacter.match(cond).search(@key).group_by(&:user_id).select{|user_id, characters| User.activated.exists?(user_id)}.to_a
    @users = @total_users.paginate :page => params[:page], :per_page => PER_PAGE
  end

end
