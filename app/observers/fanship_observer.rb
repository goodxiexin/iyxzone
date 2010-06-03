class FanshipObserver < ActiveRecord::Observer

  def after_create fanship
    fanship.fan.raw_increment :idols_count
    fanship.idol.raw_increment :fans_count
  end

  def after_destroy fanship
    fanship.fan.raw_decrement :idols_count
    fanship.idol.raw_decrement :fans_count
  end

end
