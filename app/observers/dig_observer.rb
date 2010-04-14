class DigObserver < ActiveRecord::Observer

  def after_save dig
    dig.diggable.raw_increment :digs_count
  end

  # 这个可能在某个被删除后触发
  def after_destroy dig
    dig.diggable.raw_decrement :digs_count
  end

end
