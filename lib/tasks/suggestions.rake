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
    User.all.each do |user|
      if user.friend_suggestions.count < 50 
        user.create_friend_suggestions
        puts "#{user.id} - #{user.login}: generate #{user.friend_suggestions.count} suggestions"
      end
    end
  end

  desc "计算战友推荐"
  task :create_comrade_suggestions => :environment do
    User.all.each do |user|
      user.servers.each do |server|
        if user.comrade_suggestions.all(:conditions => {:game_id => server.game_id, :server_id => server.id}).count < 25
          user.create_comrade_suggestions server
          puts "#{user.id} - #{user.login}: generate #{user.comrade_suggestions(server).count} suggestions"
        end
      end
    end
  end

end
