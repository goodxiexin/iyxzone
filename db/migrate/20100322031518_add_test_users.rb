class AddTestUsers < ActiveRecord::Migration

  def self.up
    wow = Game.find_by_name("魔兽世界")
    
    # xiexin
    3.times do |i|
      user = User.new
      user.login = "谢心#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "xiexin#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    u1 = User.find_by_email("xiexinwang@gmail.com")
    u2 = User.find_by_email("xiexin1@gmail.com")
    u3 = User.find_by_email("xiexin2@gmail.com")
    u4 = User.find_by_email("xiexin3@gmail.com")
    u1.friendships.create(:friend_id => u2.id)
    u2.friendships.create(:friend_id => u1.id)
    u1.characters.create(:game_id => wow
    # dyc
    user = User.new
    user.login = "小样"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "silentdai@gmail.com"
    user.save(false)
    user.activate    
    3.times do |i|
      user = User.new
      user.login = "小样#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "dyc#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    u1 = User.find_by_email("silentdai@gmail.com")
    u2 = User.find_by_email("dyc1@gmail.com")
    u3 = User.find_by_email("dyc2@gmail.com")
    u4 = User.find_by_email("dyc3@gmail.com")
    u1.friendships.create(:friend_id => u2.id)
    u2.friendships.create(:friend_id => u1.id)


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
    3.times do |i|
      user = User.new
      user.login = "冥浩#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "tlrn#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end
    u1 = User.find_by_email("tlrn@live.com")
    u2 = User.find_by_email("tlrn1@gmail.com")
    u3 = User.find_by_email("tlrn2@gmail.com")
    u4 = User.find_by_email("tlrn3@gmail.com")
    u1.friendships.create(:friend_id => u2.id)
    u2.friendships.create(:friend_id => u1.id)


    # jiangli
    user = User.new
    user.login = "江力"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "sodnetnin@gmail.com"
    user.save(false)
    user.activate
    3.times do |i|
      user = User.new
      user.login = "江力#{i + 1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "jiangli#{i + 1}@gmail.com"
      user.save(false)
      user.activate
    end 
    u1 = User.find_by_email("sodnetnin@gmail.com")
    u2 = User.find_by_email("jiangli1@gmail.com")
    u3 = User.find_by_email("jiangli2@gmail.com")
    u4 = User.find_by_email("jiangli3@gmail.com")
    u1.friendships.create(:friend_id => u2.id)
    u2.friendships.create(:friend_id => u1.id)

    # gaoxh
    user = User.new
    user.login = "高侠鸿"
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = "gaoxh05@sina.com.cn"
    user.save(false)
    user.activate
    3.times do |i|
      user = User.new
      user.login = "高侠鸿#{i+1}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "gaoxh#{i}@gmail.com"
      user.save(false)
      user.activate
    end
    u1 = User.find_by_email("gaoxh05@sina.com.cn")
    u2 = User.find_by_email("gaoxh1@gmail.com")
    u3 = User.find_by_email("gaoxh2@gmail.com")
    u4 = User.find_by_email("gaoxh3@gmail.com")
    u1.friendships.create(:friend_id => u2.id)
    u2.friendships.create(:friend_id => u1.id)

  end

  def self.down
  end

end
