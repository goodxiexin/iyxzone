class AddXiyouqjiData < ActiveRecord::Migration
  def self.up
GameProfession.create(
        :name => "御林军",
        :game_id => 87)
GameProfession.create(
        :name => "三星洞",
        :game_id => 87)
GameProfession.create(
        :name => "化生寺",
        :game_id => 87)
GameProfession.create(
        :name => "胭脂村",
        :game_id => 87)
GameProfession.create(
        :name => "天庭",
        :game_id => 87)
GameProfession.create(
        :name => "五庄观",
        :game_id => 87)
GameProfession.create(
        :name => "水晶宫",
        :game_id => 87)
GameProfession.create(
        :name => "普陀山",
        :game_id => 87)
GameProfession.create(
        :name => "幽冥界",
        :game_id => 87)
GameProfession.create(
        :name => "兽神山",
        :game_id => 87)
GameProfession.create(
        :name => "狮驼洞",
        :game_id => 87)
GameProfession.create(
        :name => "盘丝岭",
        :game_id => 87)
  end

  def self.down
  end
end
