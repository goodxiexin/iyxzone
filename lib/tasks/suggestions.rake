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
		my_file = File.new("f_sugguestion_data_temp", 'a')
    User.all.select{|u| u.friend_suggestions.count < 50}.each_with_index do |user, i|
			start_time = Time.now
      user.create_friend_suggestions
			time_usage = Time.now - start_time
      ram_usage = `pmap #{Process.pid} | tail -1`[6,40].strip
      puts "#{user.id} - #{user.login}: generate #{user.friend_suggestions.count} suggestions, ram usage: #{ram_usage} MB, time usage: #{time_usage} sec"
      my_file.puts " #{ram_usage}  #{time_usage}"
    end
		my_file.close
  end

  desc "计算战友推荐"
  task :create_comrade_suggestions => :environment do
		my_file = File.new("c_sugguestion_data_temp4", 'a')
    User.all.each do |user|
      user.servers.each do |server|
        if user.comrade_suggestions.all(:conditions => {:game_id => server.game_id, :server_id => server.id}).count < 25
					st = Time.now
          user.create_comrade_suggestions server
					duration = Time.now - st
					ram_usage = `pmap #{Process.pid} | tail -1`[6,40].strip
          puts "#{user.id} - #{user.login}: generate #{user.comrade_suggestions.all(:conditions => {:server_id => server.id}).count} suggestions, ram usage: #{ram_usage} MB,"
					my_file.puts "#{ram_usage} #{duration}"
        end
      end
    end
		my_file.close
  end

end
