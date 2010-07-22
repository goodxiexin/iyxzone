class AddGameAdminRole < ActiveRecord::Migration
  def self.up
    Role.create :name => "game_admin"
  end

  def self.down
  end
end
