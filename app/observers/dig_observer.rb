class DigObserver < ActiveRecord::Observer

  def after_save dig
    dig.diggable.raw_increment :digs_count
  end

end
