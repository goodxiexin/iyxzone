require 'net/http'
require 'uri'
require 'open-uri'
#require 'hpricot'
require "iconv"

namespace :users do

  desc "改邮件"
  task :change_email => :environment do
    User.all(:select => "id, email").group_by{|u| u.email.downcase}.select{|email, users| users.count > 1}.each do |email, users|
      users.shift
      puts "#{email}: destroy #{users.map(&:id).join(", ")}"
      users.map(&:id).each do |id|
        User.destroy(id)
      end
    end
  end

  desc "改名字"
  task :change_login_name => :environment do
    changed = File.open("changed1.log", "w")
    failed = File.open("failed1.log", "w")
    s = [0x4E00].pack("U")
    e = [0x9FA5].pack("U")
    reg = /^[a-zA-Z0-9_#{s}-#{e}]+$/

    # 先去掉特殊字符
    User.all.select{|u| !(u.login =~ reg)}.each do |u|
      r = /^[ \=】【\$\t\~\.\-\,。，\(\)、\^\~\`\!\?？！\\\/\*\@\·\>\<a-zA-Z0-9_#{s}-#{e}]+$/
      if r =~ u.login
        # 将空格换成_
        new_login = u.login.gsub(/[ \=】【\$\t\.\,\-。，\(\)、\^\~\`\\\/\!\?！？\*\@\·\>\<]/, '_')
        puts "#{u.id}: #{u.login} => #{new_login}"
        u.login = new_login
        u.save
        record = InvalidName.create :user_id => u.id
        UserMailer.deliver_change_nickname u, record.token
      elsif "用户#{u.id}".length > 30
        failed.write "#{u.id}: 用户#{u.id} 名字太长\n"
      elsif User.exists? :login => "用户#{u.id}"
        failed.write "#{u.id}: 用户#{u.id} 已经存在\n"
      else
        changed.write "#{u.id}: #{u.login} => 用户#{u.id}\n"
        puts "#{u.id}: #{u.login} => 用户#{u.id}\n"
        u.login = "用户#{u.id}"
        u.save
        record = InvalidName.create :user_id => u.id
        UserMailer.deliver_change_nickname u, record.token
      end
    end 
    
    # 修改重复名字
    changed.close
    failed.close
    changed = File.open("changed2.log", "w")
    failed = File.open("failed2.log", "w")
    User.all(:select => "id, login").group_by{|u| u.login.downcase}.select{|login, users| users.count > 1}.each do |login, users|
      ids = users.map(&:id)
      ids.each_with_index do |id, i|
        u = User.find(id)
        if i != 0
          if "#{login}_#{i}".length > 30
            failed.write "#{id}: #{login}_#{i} 新名字太长\n"
          elsif User.exists? :login => "#{login}_#{i}"
            failed.write "#{id}: 新名字 #{login}_#{i} 已经被使用了\n"
          else
            u.login = "#{login}_#{i}"
            u.save
            changed.write "#{id}: #{login} => #{u.login}\n"
            record = InvalidName.create :user_id => u.id
            UserMailer.deliver_change_nickname u, record.token
          end
        end
      end
    end
  end

  desc "提示那些很久没上线的人"
  task :send_long_time_no_seen => :environment do 
    users = User.find(:all, :conditions => ["last_seen_at <= ?", 1.year.ago.to_s(:db)])
    polls = Poll.hot.nonblocked.limit(3)
		news = News.hot.limit(3)
		photos = Photo.hot.limit(4)
		hot_users = User.hot.limit(6)
		games = Game.recent.limit(4)
    puts "send mail to #{users.map(&:id).join(',')}"
    users.each do |user|
      UserMailer.deliver_long_time_no_seen user, hot_users, games, photos, polls, news
    end
  end

  desc "验证魔兽世界游戏角色"
  task :verify_wow_characters => :environment do 
		g = Game.find_by_name("魔兽世界")
		characters = GameCharacter.find(:all, :conditions => {:game_id => g.id, :data => nil})
		characters.each do |char|
			puts char.server.name
			puts char.name
			enc_url = URI.escape('http://cn.wowarmory.com/character-sheet.xml?r='+char.server.name+'&n='+char.name)
      puts "verify game character #{char.name} .. #{enc_url}"
      passed = checking_info enc_url
			unless passed.nil?
				if passed
					char.update_attributes(:data => {"verify" => true, "url" => enc_url})
					char.user.notifications.create(:data => "您的 #{char.name} 通过了验证，可以点击角色名称访问其英雄榜", :category => Notification::Promotion)
				else
					char.update_attributes(:data => {"verify" => false})
					char.user.notifications.create(:data => "您的 #{char.name} 没有通过验证，请检查其正确性", :category => Notification::Promotion)
				end
			end
		end
  end

  desc "验证魔兽世界台服游戏角色"
  task :verify_wowtw_characters => :environment do 
		g = Game.find_by_name("魔兽世界（台服）")
		characters = GameCharacter.find(:all, :conditions => {:game_id => g.id, :data => nil})
		characters.each do |char|
			cArea = Iconv.iconv("gb2312", "utf8", char.server.name)
			cArea = Iconv.iconv("big5", "gb2312", cArea.first)
			cArea = Iconv.iconv("utf8", "big5", cArea.first)
			puts cArea.first
			puts char.name
			enc_url = URI.escape('http://tw.wowarmory.com/character-sheet.xml?r='+cArea.first+'&cn='+char.name)
      puts "verify game character #{char.name} .. #{enc_url}"
      passed = checking_info enc_url
			unless passed.nil?
				if passed
					char.update_attributes(:data => {"verify" => true, "url" => enc_url})
					char.user.notifications.create(:data => "您的 #{char.name} 通过了验证，可以点击角色名称访问其英雄榜", :category => Notification::Promotion)
				else
					char.update_attributes(:data => {"verify" => false})
					char.user.notifications.create(:data => "您的 #{char.name} 没有通过验证，请检查其正确性", :category => Notification::Promotion)
				end
			end
		end
  end

  def checking_info(enc_url)
    url = open(enc_url)
		doc = Hpricot(url)
    char_name = doc.search("//div[@class='charNameHeader']").inner_html
    !char_name.blank?
  rescue OpenURI::HTTPError
    puts "Unable to open url: " + url
    return nil
  rescue
    puts 'unknown error'
    return nil
  end

end
