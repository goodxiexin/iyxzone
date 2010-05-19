class User::GameSuggestionsController < UserBaseController

  layout 'app'

  def index
    @game_tags = Tag.game_tags 
    @interested_games = current_user.interested_games
    @game_attentions = current_user.game_attentions
    @game_list = Game.hot.paginate :page => params[:page], :per_page => 8 
    @beta_list = Game.beta.paginate :page => params[:page], :per_page => 8
  end

  def game_tags
    @keys = params[:selected_tags].split(%r{,\s*})
    @len = @keys.length / 2 + 1
    @game_tags = Rails.cache.fetch "game_tags",:expires_in => 24.hours do
      Game.all.map {|g| {:id => g.id, :tags => g.tags.map(&:name)}}
    end
    @ids = []
    @game_tags.each do |info|
      id = info[:id]
      tags = info[:tags]
      @ids << id if (tags & @keys).length >= @len
    end
    @games = Game.find(@ids)
    @games = @games.select(&:relative_new?) if params[:new_game] == 'true'
    @remote = {:update => 'game_suggestion_area', :url => {:action => 'game_tags', :selected_tags => params[:selected_tags]}}
    render :partial => "games", :object => @games.paginate(:page => params[:page], :per_page => 20)
  end
=begin
  def game_suggestion
    # giving scores to each game that user has played before
    tag_score = {}
    tag_score.default = 0
    @current_games = []
    current_user.games.each do |game|
      @current_games << game
      game.tags.each do |tag|
        tag_score[tag.id] += (game.find_rating_by_user(current_user).rating - 3)
      end
    end

    # giving scores to all tag related games
    game_score = {}
    game_score.default = 0
    @tagged_games.each do |game|
      game.tags.each do |tag|
        game_score[game.id] += tag_score[tag.id]
      end
    end

    # giving final scores from personal score 60% and user ratings (attention) 40%
    max_score = game_score.values.max
    max_score = [1, max_score].max
    max_attention = @tagged_games.sort_by(&:attentions_count).last.attentions_count
    max_attention = [1, max_attention].max #prevent this values 0
    @tagged_games.each do |game|
      if game.new_game?
        game_score[game.id] = (6 * game_score[game.id]/max_score)+(4 * game.attentions_count/max_attention)
      else
        game_score[game.id] = (6 * game_score[game.id]/max_score)+(0.8 * game.average_rating)
      end
    end

    # return games with score order
    game_scores = game_score.sort{|a,b| b[1] <=> a[1]}
    @games = []
    game_scores.each do |game_list|
      game = Game.find(game_list[0])
      unless @current_games.include?(game)
        @games << game
      end
    end
    return @games
  end
=end
end

