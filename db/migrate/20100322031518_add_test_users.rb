class AddTestUsers < ActiveRecord::Migration

  def self.up
    wow = Game.find_by_name("魔兽世界")
    tow = Game.find_by_name("永恒之塔")    

    # xiexin
    xiexin = User.find_by_email("xiexinwang@gmail.com")
    xiexin.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "xiexin的角色", :level => 100)
    20.times do |i|
      user = User.new
      user.login = "谢心#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "xiexin#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    18.times do |i|
      user = User.find_by_email("xiexin#{i+1}@gmail.com")
      xiexin.friendships.create(:friend_id => user.id)
      user.friendships.create(:friend_id => xiexin.id)
      user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "xiexin#{i+1}的角色", :level => 100)
    end
    user = User.find_by_email("xiexin19@gmail.com")
    user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "xiexin19的角色", :level => 100)
    user = User.find_by_email("xiexin20@gmail.com")
    user.characters.create(:game_id => tow.id, :area_id => tow.areas.first.id, :server_id => tow.areas.first.servers.first.id, :race_id => tow.races.first.id, :profession_id => tow.professions.first.id, :name => "xiexin20的角色", :level => 100)

    # dyc
    user = User.new
    user.login = "小样"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "silentdai@gmail.com"
    user.save(false)
    user.activate    
    dyc = User.find_by_email("silentdai@gmail.com")
    dyc.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "小样的角色", :level => 100)
    20.times do |i|
      user = User.new
      user.login = "小样#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "dyc#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    18.times do |i|
      user = User.find_by_email("dyc#{i+1}@gmail.com")
      dyc.friendships.create(:friend_id => user.id)
      user.friendships.create(:friend_id => dyc.id)
      user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "小样#{i+1}的角色", :level => 100)
    end
    user = User.find_by_email("dyc19@gmail.com")
    user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "小样19的角色", :level => 100)
    user = User.find_by_email("dyc20@gmail.com")
    user.characters.create(:game_id => tow.id, :area_id => tow.areas.first.id, :server_id => tow.areas.first.servers.first.id, :race_id => tow.races.first.id, :profession_id => tow.professions.first.id, :name => "小样20的角色", :level => 100)


    # gaoxh04, user0, user4, miliniu
    # 都已经创建过了
 
    # tlrn
    user = User.new
    user.login = "冥浩"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "tlrn@live.com"
    user.save(false)
    user.activate
    tlrn = User.find_by_email("tlrn@live.com")
    tlrn.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "tlrn的角色", :level => 100)
    20.times do |i|
      user = User.new
      user.login = "冥浩#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "tlrn#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    18.times do |i|
      user = User.find_by_email("tlrn#{i+1}@gmail.com")
      user.friendships.create(:friend_id => tlrn.id)
      tlrn.friendships.create(:friend_id => user.id)
      user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "tlrn#{i}的角色", :level => 100)
    end
    user = User.find_by_email("tlrn19@gmail.com")
    user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "tlrn19的角色", :level => 100)
    user = User.find_by_email("tlrn20@gmail.com")
    user.characters.create(:game_id => tow.id, :area_id => tow.areas.first.id, :server_id => tow.areas.first.servers.first.id, :race_id => tow.races.first.id, :profession_id => tow.professions.first.id, :name => "tlrn20的角色", :level => 100)


    # jiangli
    user = User.new
    user.login = "江力"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "sodnetnin@gmail.com"
    user.save(false)
    user.activate
    jiangli = User.find_by_email("sodnetnin@gmail.com")
    jiangli.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "江力的角色", :level => 100)
    20.times do |i|
      user = User.new
      user.login = "江力#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "jiangli#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    18.times do |i|
      user = User.find_by_email("jiangli#{i+1}@gmail.com")
      user.friendships.create(:friend_id => jiangli.id)
      jiangli.friendships.create(:friend_id => user.id)
      user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "江力#{i+1}的角色", :level => 100)
    end
    user = User.find_by_email("jiangli19@gmail.com")
    user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "江力19的角色", :level => 100)
    user = User.find_by_email("jiangli20@gmail.com")
    user.characters.create(:game_id => tow.id, :area_id => tow.areas.first.id, :server_id => tow.areas.first.servers.first.id, :race_id => tow.races.first.id, :profession_id => tow.professions.first.id, :name => "江力20的角色", :level => 100)

    # gaoxh
    user = User.new
    user.login = "高侠鸿"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "gaoxh05@sina.com.cn"
    user.save(false)
    user.activate
    gaoxh = User.find_by_email("gaoxh05@sina.com.cn")
    user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "色魔的角色", :level => 100)
    20.times do |i|
      user = User.new
      user.login = "高侠鸿#{i+1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "gaoxh#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    18.times do |i|
      user = User.find_by_email("gaoxh#{i+1}@gmail.com")
      user.friendships.create(:friend_id => gaoxh.id)
      gaoxh.friendships.create(:friend_id => user.id)
      user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "色魔#{i}的角色", :level => 100)
    end
    user = User.find_by_email("gaoxh19@gmail.com")
    user.characters.create(:game_id => wow.id, :area_id => wow.areas.first.id, :server_id => wow.areas.first.servers.first.id, :race_id => wow.races.first.id, :profession_id => wow.professions.first.id, :name => "色魔19的角色", :level => 100)
    user = User.find_by_email("gaoxh20@gmail.com")
    user.characters.create(:game_id => tow.id, :area_id => tow.areas.first.id, :server_id => tow.areas.first.servers.first.id, :race_id => tow.races.first.id, :profession_id => tow.professions.first.id, :name => "色魔20的角色", :level => 100)
  end

  def self.down
  end

end
