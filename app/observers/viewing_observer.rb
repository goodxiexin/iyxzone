class ViewingObserver < ActiveRecord::Observer

  def after_create viewing
    viewing.viewable.raw_increment :viewings_count
  end

end
