class User::CharactersController < UserBaseController

	def new
    @game = Game.find(params[:gid])
		@games = [@game]
    @areas = @game.areas
    @races = @game.races
    @professions = @game.professions
	  @character = GameCharacter.new
  end

  def show
    @character = GameCharacter.find(params[:id])
    render :json => @character.to_json(:include => [:user => {:only => [:name]}])
  end

	def friend_players
		@game = Game.find(params[:gid])
		@user_ids = @game.characters.by(current_user.friend_ids).map(&:user_id)		
		@users = User.find(@user_ids).paginate :page => params[:page], :per_page => 9
    @remote = {:update => 'game_friend_players', :url => {:action => 'friend_players', :gid => @game.id}}
	end

  def index
    if params[:guild_id].blank? #@guild.blank?
      @characters = current_user.characters
    else
      # TODO, hide 3,4
      @characters = GameCharacter.all(:joins => "inner join memberships on memberships.status IN (3,4) and memberships.character_id = game_characters.id and memberships.guild_id = #{@guild.id}")
    end
    render :json => @characters, :only => [:id, :name]  
  end

	def create
		@character = current_user.characters.build(params[:character] || {})

    if @character.save
      render_js_code "facebox.close()"
    else
		  render :update do |page|
				page.replace_html 'errors', :inline =>"<%= error_messages_for :character, :header_message => '遇到以下问题无法保存', :message => nil %>"
			end
		end
	end

protected
  
  def setup
    if ["index"].include? params[:action]
      @guild = Guild.find(params[:guild_id]) unless params[:guild_id].blank?
    end
  end

end
