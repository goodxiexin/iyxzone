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

	def new
    unless params[:server_id].nil?
      @except = ComradeSuggestion.find(params[:except_ids])
      @server = GameServer.find(params[:server_id])
    else
      @except = FriendSuggestion.find(params[:except_ids])
    end

		if !params[:server_id].nil?
			@suggestions = current_user.find_or_create_comrade_suggestions(@server).reject{|s| @except.include?(s)}
      if @suggestions.blank?
        # this could barely happen, but it's still possible
        # in this case, we just return the origin comrade suggestion
        @suggestion = ComradeSuggestion.find(params[:sid])
      else
        @suggestion = @suggestions.sort_by{rand}.first
      end
			render :partial => 'comrade_suggestion', :object => @suggestion
		else
			@suggestions = current_user.find_or_create_friend_suggestions.reject{|s| @except.include?(s)}
      if @suggestions.blank?
        # this could barely happen, but it's still possible
        # in this case, we just return the origin friend suggestions 
        @suggestion = FriendSuggestion.find(params[:sid])
      else
        @suggestion = @suggestions.sort_by{rand}.first
      end
      if params[:nicer].nil?
			  render :partial => 'friend_suggestion', :object => @suggestion
      else
        render :partial => 'nicer_friend_suggestion', :object => @suggestion
      end
		end
	end

end
