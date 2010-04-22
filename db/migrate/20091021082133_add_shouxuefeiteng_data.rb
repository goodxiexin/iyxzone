class AddShouxuefeitengData < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "人类剑士",
        :game_id => 63)
GameProfession.create(
        :name => "人类法师",
        :game_id => 63)
GameProfession.create(
        :name => "人类游侠",
        :game_id => 63)
GameProfession.create(
        :name => "兽族战士",
        :game_id => 63)
GameProfession.create(
        :name => "兽族祭祀",
        :game_id => 63)
GameProfession.create(
        :name => "兽族猎人",
        :game_id => 63)
  end

  def self.down
  end
end
