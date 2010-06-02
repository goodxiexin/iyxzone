class FanshipObserver < ActiveRecord::Observer

  def after_create fanship
    fanship.idol.raw_increment :fans_count
  end

  def after_destroy fanship
    fanship.idol.raw_decrement :fans_count
  end

end
