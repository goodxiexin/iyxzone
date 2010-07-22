class AddFengsehuanxiangol < ActiveRecord::Migration
  def self.up
			game = Game.create(
			:name => "风色幻想ol",
			:official_web => "http://ago.gfyoyo.com.cn/",
			:sale_date => "2010-6-7",
			:company => "弘煜科技",
			:agent => "悠游网",
			:description => "台湾大型角色扮演游戏")
			game.tag_list = "Q版, 奇幻, 角色扮演, 道具收费, 回合战斗, 3D"
			game.save
			GameServer.create(:name => "安洁妮", :game_id => game.id)
			GameServer.create(:name => "露菲亚", :game_id => game.id)
			GameServer.create(:name => "朱里安", :game_id => game.id)
			GameServer.create(:name => "伊吉尔", :game_id => game.id)
			GameServer.create(:name => "芙丽嘉", :game_id => game.id)
			GameServer.create(:name => "希路德", :game_id => game.id)
			GameServer.create(:name => "克菈菈", :game_id => game.id)
			GameServer.create(:name => "雷伊莎", :game_id => game.id)
			GameServer.create(:name => "夏露露", :game_id => game.id)
			GameServer.create(:name => "梦娜娜", :game_id => game.id)
			GameProfession.create(:name => "旅人", :game_id => game.id)
			GameProfession.create(:name => "剑斗士", :game_id => game.id)
			GameProfession.create(:name => "弓斗士", :game_id => game.id)
			GameProfession.create(:name => "魔道师", :game_id => game.id)
			GameProfession.create(:name => "治愈师", :game_id => game.id)
			GameProfession.create(:name => "夜行者", :game_id => game.id)
			GameProfession.create(:name => "魔法骑士", :game_id => game.id)
			GameProfession.create(:name => "枪斗专家", :game_id => game.id)
			GameProfession.create(:name => "执事/女仆", :game_id => game.id)
			GameProfession.create(:name => "武斗专家", :game_id => game.id)
  end

  def self.down
  end
end
