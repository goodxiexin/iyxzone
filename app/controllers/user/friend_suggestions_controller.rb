class User::FriendSuggestionsController < UserBaseController

	layout 'app'

	def index
    @games = Game.find(:all, :order => 'pinyin ASC')
		@friend_suggestions = current_user.find_or_create_friend_suggestions.paginate :page => params[:page], :per_page => 6
		@comrade_suggestions = {}
		current_user.servers.each do |s|
			@comrade_suggestions[s.id] = current_user.find_or_create_comrade_suggestions(s).paginate :page => params[:page], :per_page => 3
		end
	end

	def friend
		@games = Game.find(:all, :order => 'pinyin ASC')
    @friend_suggestions = current_user.find_or_create_friend_suggestions.paginate :page => params[:page], :per_page => 10
	end

	def comrade
    @games = Game.find(:all, :order => 'pinyin ASC')
    @server = GameServer.find(params[:server_id])
		@comrade_suggestions = current_user.find_or_create_comrade_suggestions(@server).paginate :page => params[:page], :per_page => 10
	end

	def user_search
		unless params[:server_id].nil?
			@server = GameServer.find(params[:server_id]) 
			@users = User.search(params[:key])
			@comrade_suggestions = current_user.find_or_create_comrade_suggestions(@server)
			@comrade_suggestions.collect!{|suggestion| suggestion.comrade}
			@suggestions = @comrade_suggestions & @users
		else
			@users = User.search(params[:key])
			@friend_suggestions = current_user.find_or_create_friend_suggestions
			@friend_suggestions.collect!{|suggestion| suggestion.suggested_friend}
			@suggestions = @friend_suggestions & @users
		end
		@suggestions = @suggestions.paginate :page => params[:page], :per_page => 10
	end

	def character_search
		unless params[:server_id].nil?
			@server = GameServer.find(params[:server_id]) 
			@characters = GameCharacter.search(params[:key])
			@comrade_suggestions = current_user.find_or_create_comrade_suggestions(@server)
			@comrade_suggestions.collect!{|suggestion| suggestion.comrade.characters}.flatten!
			@suggestions = @comrade_suggestions & @characters
		else
			@characters = GameCharacter.search(params[:key])
			@friend_suggestions = current_user.find_or_create_friend_suggestions
			@friend_suggestions.collect!{|suggestion| suggestion.suggested_friend.characters}.flatten!
			@suggestions = @friend_suggestions & @characters
		end
		@suggestions = @suggestions.paginate :page => params[:page], :per_page => 10
	end

	def new
    unless params[:server_id].nil?
      @except = ComradeSuggestion.find(params[:except_ids])
      @server = GameServer.find(params[:server_id])
    else
      @except = FriendSuggestion.find(params[:except_ids])
    end

		if !params[:server_id].nil?
			@suggestion = current_user.find_or_create_comrade_suggestions(@server).reject{|s| @except.include?(s)}.sort_by{rand}.first
			render :partial => 'comrade_suggestion', :object => @suggestion
		elsif !params[:nicer].nil?
			@suggestion = current_user.find_or_create_friend_suggestions.reject{|s| @except.include?(s)}.sort_by{rand}.first
			render :partial => 'nicer_friend_suggestion', :object => @suggestion
		else
			@suggestion = current_user.find_or_create_friend_suggestions.reject{|s| @except.include?(s)}.sort_by{rand}.first
			render :partial => 'friend_suggestion', :object => @suggestion
		end
	end

end
