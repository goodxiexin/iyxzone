class User::SearchController < UserBaseController

  layout 'app'

  PER_PAGE = 20

  def user
    @fql = {:login => params[:key]}
    @users = User.search(@fql, :sort => "created_at DESC", :page => params[:page], :per_page => PER_PAGE)
    logger.error @users.class.name
  end

  def character
    @fql = {}
    @fql[:name] = params[:key] if !params[:key].blank?
    @fql[:game_id] = params[:game_id] if !params[:game_id].blank?
    @fql[:area_id] = params[:area_id] if !params[:area_id].blank?
    @fql[:server_id] = params[:server_id] if !params[:server_id].blank?
		@total_users = GameCharacter.search(@fql).group_by(&:user).to_a#.select{|user, characters| user.active?}.to_a
    @users = @total_users.paginate :page => params[:page], :per_page => PER_PAGE
  end

end
