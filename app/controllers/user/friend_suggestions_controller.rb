class User::FriendSuggestionsController < UserBaseController

	layout 'app'

	def index
    @games = Game.find(:all, :order => 'pinyin ASC')
		@friend_suggestions = current_user.friend_suggestions.paginate :page => params[:page], :per_page => 12, :include => [{:suggested_friend => [:profile, {:characters => [:game, :server]}]}]
		@comrade_suggestions = {}
		current_user.servers.each do |s|
			@comrade_suggestions[s.id] = current_user.comrade_suggestions.paginate :page => params[:page], :per_page => 6, :conditions => {:server_id => s.id}, :include => [{:comrade => [:profile, {:characters => [:game, :server]}]}]
		end
	end

	def friend
		@games = Game.find(:all, :order => 'pinyin ASC')
    @friend_suggestions = current_user.friend_suggestions.paginate :page => params[:page], :per_page => 20, :include => [{:suggested_friend => [:profile, {:characters => [:game, :server]}]}]
	end

	def comrade
    @games = Game.find(:all, :order => 'pinyin ASC')
    @server = GameServer.find(params[:server_id])
		@comrade_suggestions = current_user.comrade_suggestions.paginate :page => params[:page], :per_page => 20, :conditions => {:server_id => @server.id}, :include => [{:comrade => [:profile, {:characters => [:game, :server]}]}]
	end

	def new
    unless params[:server_id].nil?
      @except = ComradeSuggestion.find(params[:except_ids])
      @server = GameServer.find(params[:server_id])
    else
      @except = FriendSuggestion.find(params[:except_ids])
    end

		if !params[:server_id].nil?
      @suggestion = ComradeSuggestion.random(:limit => 1, :conditions => {:user_id => current_user.id}, :except => @except)
      if @suggestion.blank?
        # in this case, we just return the origin comrade suggestion
        @suggestion = ComradeSuggestion.find(params[:sid])
      else
        @suggestion = @suggestion[0]
      end
			render :partial => 'comrade_suggestion', :object => @suggestion
		else
			@suggestion = FriendSuggestion.random(:limit => 1, :conditions => {:user_id => current_user.id}, :except => @except)
      if @suggestion.blank?
        # in this case, we just return the origin friend suggestions 
        @suggestion = FriendSuggestion.find(params[:sid])
      else
        @suggestion = @suggestion[0]
      end
      if params[:nicer].nil?
			  render :partial => 'friend_suggestion', :object => @suggestion
      else
        render :partial => 'nicer_friend_suggestion', :object => @suggestion
      end
		end
	end

end
