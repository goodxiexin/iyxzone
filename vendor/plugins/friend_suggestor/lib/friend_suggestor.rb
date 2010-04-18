# FriendSuggestor
module FriendSuggestor

	FRIEND_SUGGESTION_SET_SIZE = 100

	COMRADE_SUGGESTION_SET_SIZE = 50

	def collect_friends
		friend_suggestions = {} # (user_id, frequency) pair
		friend_suggestions.default = 0

    # friend's friends
    friends.each do |friend|
      friend.friends.each do |f|
        if f != self and !self.has_friend?(f)
          friend_suggestions[f.id] += 10  # 是好友的好友加10分
        end
      end
    end

		# events
		all_events.each do |event|
			event.participants.each do |p|
				if p != self and !self.has_friend?(p)
					friend_suggestions[p.id] += 10 # 参加同一个活动加10分
				end
			end
		end	

		#	guilds
		all_guilds.each do |guild|
			guild.people.each do |p|
				if p != self and !self.has_friend?(p)
					friend_suggestions[p.id] += 10  # 参加同一个工会加10分
				end
			end
		end

		# user within same game
		games.each do |game|
			game.users.each do |u|
				if u != self and !self.has_friend?(u)
					friend_suggestions[u.id] += 3 # 相同游戏加3分
				end
			end
		end

    # radom picked users
    User.random(:limit => FRIEND_SUGGESTION_SET_SIZE, :except => friends.map(&:id).concat([self.id]), :conditions => "activated_at IS NOT NULL").each do |u|
      friend_suggestions[u.id] += 1 # 加1分
    end

    # sort by score and return first FRIEND_SUGGESTION_SET_SIZE 
    friend_suggestions.sort{|a, b| b[1] <=> a[1]}[0..(FRIEND_SUGGESTION_SET_SIZE - 1)].map{|info| info[0]}
	
	end

	def destroy_obsoleted_friend_suggestions friend
		FriendSuggestion.delete_all(:user_id => id, :suggested_friend_id => friend.id)
	end

	def fetch_friend_suggestions
    # 放后台去，这个还比较好办
    # 因为这个不像推荐战友，推荐好友为空几乎是不可能的
=begin
    if friend_suggestions.count == 0
      self.create_friend_suggestions # this should happen barely
      self.reload
    end
=end

    friend_suggestions
  end

  def create_friend_suggestions
		# now destroy all existing friend suggestions
		FriendSuggestion.delete_all(:user_id => id)

		# construct new suggestions and insert into database
		values = []
		collect_friends.each {|friend_id| values << "(NULL,#{id},#{friend_id})" }

    # this is almost impossible
    return friend_suggestions if values.blank?

    # insert suggestions within one single sql
		sql = "insert into friend_suggestions values #{values.join(',')}"
		ActiveRecord::Base.connection.execute(sql)
	end 
	
  # this function is expensive, so we should invoke it occasionally	
	def collect_comrades server
		comrade_suggestions = {}
		comrade_suggestions.default =	0	
    candidates = server.is_temp? ? server.game.users : server.users

		candidates.each do |u|
			if u != self and !self.has_friend?(u)	and !self.wait_for?(u) and !u.wait_for?(self)
				comrade_suggestions[u.id] += 20 * u.common_friends_with(self).count
				comrade_suggestions[u.id] += 10 * u.common_events_with(self).count
				comrade_suggestions[u.id] += 10 * u.common_guilds_with(self).count
			end
		end

    # sort by score
		comrade_suggestions.sort{|a,b| b[1] <=> a[1]}[0..(COMRADE_SUGGESTION_SET_SIZE - 1)].map{|info| info[0]}
					
	end

	def destroy_obsoleted_comrade_suggestions comrade
		ComradeSuggestion.delete_all(:user_id => id, :comrade_id => comrade.id)
	end

	def fetch_comrade_suggestions server
		comrade_suggestions.all(:conditions => {:game_id => server.game_id, :server_id => server.id})

    # 本来这里，如果没有的话(或者推荐的玩家很少的时候)，就进行计算
    # 但是考虑到如果该游戏玩家基本没有，那岂不是每次都要计算，而且计算一次的开销较大
    # 所以现在就把计算放到了后台，当服务器比较空闲的时候就计算下
=begin 
    if suggestions.blank?
      self.create_comrade_suggestions server # this happens barely
      self.reload
      suggestions = comrade_suggestions.all(:conditions => {:game_id => server.game_id, :server_id => server.id})
    end
=end
  end

  def create_comrade_suggestions server
    # destroy old suggestions
    ComradeSuggestion.delete_all(:user_id => id, :game_id => server.game_id, :server_id => server.id)

	  # construct new suggestions and insert into database
	  values = []
	  collect_comrades(server).each do |friend_id|
  		if server.game.no_areas?
	  		values << "(NULL, #{id}, #{friend_id}, #{server.game_id}, NULL, #{server.id})"
		  else
			  values << "(NULL, #{id}, #{friend_id}, #{server.game_id}, #{server.area_id}, #{server.id})"
		  end
	  end

    # this is quite possible if no users play this game
		return if values.blank?

    # insert suggestions with one single sql
	  sql = "insert into comrade_suggestions values #{values.join(',')}"
	  ActiveRecord::Base.connection.execute(sql)
	end 

end
