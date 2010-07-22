class AttentionObserver < ActiveRecord::Observer

  def after_create attention
    attention.attentionable.raw_increment :attentions_count
  end

  def after_destroy attention
    attention.attentionable.raw_decrement :attentions_count
  end

end
