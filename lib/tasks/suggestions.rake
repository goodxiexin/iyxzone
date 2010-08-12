namespace :suggestions do

  desc "删除所以的好友建议"
  task :delete_all_friend_suggestions => :environment do
    FriendSuggestion.delete_all
  end

  desc "删除所有的战友建议"
  task :delete_all_comrade_suggestions => :environment do
    ComradeSuggestion.delete_all
  end

  desc "计算好友推荐"
  task :create_friend_suggestions => :environment do
    # 已经显示不满一页的时候再重新计算
    count = User.count
    offset = 0
    step = 1000
    while offset < count
      s = Time.now
      User.offset(offset).limit(step).all(:select => "id").select{|u| u.friend_suggestions.count < 20}.each_with_index do |user, i|
        user.create_friend_suggestions
      end
      e = Time.now
      puts "#{e-s} sec: generate #{step} users' friend suggestions"
      offset = offset + step
    end
    puts "#{Time.now - s} sec"
  end

  desc "计算战友推荐"
  task :create_comrade_suggestions => :environment do
    count = User.count
    offset = 0
    step = 1000
    while offset < count
      s = Time.now
      User.offset(offset).limit(step).all(:select => "id").each do |user|
        user.servers.each do |server|
          if user.comrade_suggestions.match(:server_id => server.id).count < 20
            user.create_comrade_suggestions server
          end
        end
      end
      e = Time.now
      puts "#{e-s} sec: generate #{step} user's comrade suggestions"
      offset = offset + step
    end
  end

end
