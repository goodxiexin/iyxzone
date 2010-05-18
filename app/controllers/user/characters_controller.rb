class User::CharactersController < UserBaseController

	def new
		if params[:gid].nil?
			@game = nil
			@games = Game.find(:all, :order => 'pinyin ASC')
		else
			@game = Game.find(params[:gid])
		end
	  @character = GameCharacter.new
  end

  def show
    @character = GameCharacter.find(params[:id])
    render :json => @character.to_json(:include => [:user => {:only => [:name]}])
  end

  def index
    if @guild.blank?
      @characters = current_user.characters
    else
      @characters = GameCharacter.all(:joins => "inner join memberships on memberships.status IN (3,4) and memberships.character_id = game_characters.id and memberships.guild_id = #{@guild.id}")
    end
    render :json => @characters, :only => [:id, :name]  
  end

	def create
		@character = current_user.characters.build(params[:character] || {})

		#hack do not know how to pass game id when collection select disabled
		if @character.game_id.nil?
			@character.game_id = @character.area.game_id
		end
		unless @character.save
		  render :update do |page|
				page << "Iyxzone.enableButton($('new_character_submit'),'完成');"
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
