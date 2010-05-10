require 'net/http'
require 'uri'
require 'open-uri'
require 'hpricot'
require "iconv"

namespace :users do

  desc "提示那些很久没上线的人"
  task :send_long_time_no_seen => :environment do 
    users = User.find(:all, :conditions => ["last_seen_at <= ?", 1.week.ago.to_s(:db)])
    puts "send mail to #{users.map(&:id).join(',')}"
    users.each do |user|
      UserMailer.deliver_long_time_no_seen user
    end
  end

  desc "验证魔兽世界游戏角色"
  task :verify_wow_characters => :environment do 
		g = Game.find_by_name("魔兽世界")
		characters = GameCharacter.find(:all, :conditions => {:game_id => g.id, :data => nil})
		characters.each do |char|
			puts "verify game character #{char.name} .."
			enc_url = URI.escape('http://cn.wowarmory.com/character-sheet.xml?r='+char.server.name+'&n='+char.name)
			unless checking_info(enc_url).nil?
				if checking_info(enc_url)
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
			puts "verify game character #{char.name} .."
			enc_url = URI.escape('http://tw.wowarmory.com/character-sheet.xml?r='+cArea.first+'&cn='+char.name)
			unless checking_info(enc_url).nil?
				if checking_info(enc_url)
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
    url_object = open_url(enc_url)
		unless url_object == false
			parsed_url = parse_url(url_object)
			charName = parsed_url.search("//div[@class='charNameHeader']").inner_html
			if charName==''
				return false
			else
				return true
			end
		else
			return nil
		end
  end

  def open_url(url)
    url_object = nil
    begin
      url_object = open(url)
    rescue
      puts "Unable to open url: " + url
			return false
    end
    return url_object
  end

  def parse_url(url_object)
    doc = nil
    begin
      doc = Hpricot(url_object)
    rescue
      puts 'Could not parse url: ' + url_object.base_uri.to_s
    end
    puts 'Crawling url ' + url_object.base_uri.to_s
    return doc
  end

end
