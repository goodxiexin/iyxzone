class MiniTopicAttentionObserver < ActiveRecord::Observer

  def after_create attention
    game = Game.find_by_name attention.topic_name
    if !game.nil?
      game.raw_increment :attentions_count
      attention.user.raw_increment :game_attentions_count
    end
    # TODO: event 和 guild 呢，也要在这看？
  end

  def after_destroy attention
    game = Game.find_by_name attention.topic_name
    if !game.nil?
      game.raw_decrement :attentions_count
      attention.user.raw_decrement :game_attentions_count
    end
  end

end
