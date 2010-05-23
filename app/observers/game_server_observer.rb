class GameServerObserver < ActiveRecord::Observer

  def after_create server
    server.game.raw_increment :servers_count
    server.area.raw_increment :servers_count unless server.area.blank?
  end

  def after_destroy server
    server.game.raw_decrement :servers_count
    server.area.raw_decrement :servers_count unless server.area.blank?
  end

end
