class AddYuyanonlineData < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "破坏型玄武",
        :game_id => 71)
GameProfession.create(
        :name => "捍卫型玄武",
        :game_id => 71)
GameProfession.create(
        :name => "神知型剑仙",
        :game_id => 71)
GameProfession.create(
        :name => "暗灵型剑仙",
        :game_id => 71)
GameProfession.create(
        :name => "御火型魔魅",
        :game_id => 71)
GameProfession.create(
        :name => "冰控型魔魅",
        :game_id => 71)
  end

  def self.down
  end
end
