namespace :suggestions do

  desc "计算好友推荐"
  task :create_friend_suggestions => :environment do
    puts "start creating friend suggestions"
    start_time = Time.now
    User.all.each do |user|
      if user.friend_suggestions.count < 50 
        user.create_friend_suggestions
        puts "#{user.id} - #{user.login}: generate #{user.friend_suggestions.count} suggestions"
      end
    end
    end_time = Time.now
    puts "finished: #{end_time - start_time} S"
  end

  desc "计算战友推荐"
  task :create_comrade_suggestions => :environment do
    puts "start creating comrade suggestions"
    start_time = Time.now
    User.all.each do |user|
      user.servers.each do |server|
        if user.comrade_suggestions(server).count < 25
          user.create_comrade_suggestions server
          puts "#{user.id} - #{user.login}: generate #{user.comrade_suggestions(server).count} suggestions"
        end
      end
    end
    end_time = Time.now
    puts "finished: #{end_time - start_time} S"
  end

end
