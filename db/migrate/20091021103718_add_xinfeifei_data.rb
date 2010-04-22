class AddXinfeifeiData < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "骑士",
        :game_id => 73)
GameProfession.create(
        :name => "战士",
        :game_id => 73)
GameProfession.create(
        :name => "祭祀",
        :game_id => 73)
GameProfession.create(
        :name => "牧师",
        :game_id => 73)
GameProfession.create(
        :name => "法师",
        :game_id => 73)
GameProfession.create(
        :name => "巫师",
        :game_id => 73)
GameProfession.create(
        :name => "弓手",
        :game_id => 73)
GameProfession.create(
        :name => "刺客",
        :game_id => 73)
  end

  def self.down
  end
end
