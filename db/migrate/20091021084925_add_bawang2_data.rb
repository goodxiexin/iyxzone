class AddBawang2Data < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "法师",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "骑士",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "弓箭手",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "猎人",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "狂战士",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "术士",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "召唤使",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "游侠",                                                          
        :game_id => 65)
GameProfession.create(
        :name => "剑客",                                                          
        :game_id => 65)
  end

  def self.down
  end
end
