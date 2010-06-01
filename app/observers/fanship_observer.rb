class FanshipObserver < ActiveRecord::Observer

  def after_create fanship
    fanship.idol.increment :fans_count
  end

  def after_destroy fanship
    fanship.idol.decrement :fans_count
  end

end
