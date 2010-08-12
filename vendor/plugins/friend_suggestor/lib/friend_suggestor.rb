# FriendSuggestor
module FriendSuggestor

	FRIEND_SUGGESTION_SET_SIZE = 50

	COMRADE_SUGGESTION_SET_SIZE = 50

	def collect_friends
    except_ids = ([self.id] + self.friend_ids + self.request_friend_ids + self.requested_friend_ids + self.friend_suggestions.map(&:suggested_friend_id) + self.comrade_suggestions.map(&:comrade_id) + User.match(:is_idol => true).all(:select => "id").map(&:id)).uniq

    if is_idol?
      except_ids.concat fan_ids
    end
  
    game_ids = self.games.map(&:id)
    remain = FRIEND_SUGGESTION_SET_SIZE
    suggestions = []
    count = GameCharacter.match(:game_id => game_ids).count
    
    if count <= remain
      return (GameCharacter.match(:game_id => game_ids).all(:select => "user_id").map(&:user_id).uniq - except_ids)
    end

    # 如果总量不是很大，随机将会很慢，因为老是有重复的
    if count <= 6 * remain
      return (GameCharacter.match(:game_id => game_ids).all(:select => "user_id").map(&:user_id).uniq - except_ids).sort{rand(2)}[0..(FRIEND_SUGGESTION_SET_SIZE - 1)]
    end

    while true
      offset = rand(count)
      user_ids = GameCharacter.match(:game_id => game_ids).offset(offset).limit(remain).all(:select => "user_id").map(&:user_id).uniq - except_ids
      except_ids = user_ids + except_ids
      suggestions = suggestions.concat(user_ids).uniq
      remain = FRIEND_SUGGESTION_SET_SIZE - suggestions.count
      if remain <= 0
        break
      end
    end
    suggestions
	end

	def destroy_obsoleted_friend_suggestions friend
		FriendSuggestion.delete_all(:user_id => id, :suggested_friend_id => friend.id)
	end

	def fetch_friend_suggestions
    suggestions = friend_suggestions

    suggestions
  end

  def create_friend_suggestions
		# now destroy all existing friend suggestions
		FriendSuggestion.delete_all(:user_id => id)

		# construct new suggestions and insert into database
		values = []
		f_s = collect_friends
		f_s.each {|friend_id| values << "(NULL,#{id},#{friend_id})" }
		f_s.clear

    # this is almost impossible
    return if values.blank?

    # insert suggestions within one single sql
		sql = "insert into friend_suggestions values #{values.join(',')}"
		values.clear
		ActiveRecord::Base.connection.execute(sql)
	  e = Time.now
  end 
	
	def collect_comrades server
    except_ids = ([self.id] + self.friend_ids + self.requested_friend_ids + self.requested_friend_ids + self.friend_suggestions.map(&:suggested_friend_id) + self.comrade_suggestions.map(&:comrade_id) + User.match(:is_idol => true).all(:select => "id").map(&:id)).uniq

    if is_idol?
      except_ids.concat fan_ids
    end

    remain = COMRADE_SUGGESTION_SET_SIZE
    suggestions = []
    count = GameCharacter.match(:server_id => server.id).count

    if count <= remain
      return (GameCharacter.match(:server_id => server.id).all(:select => "user_id").map(&:user_id).uniq - except_ids)
    end

    if count <=  6 * remain
      return (GameCharacter.match(:server_id => server.id).all(:select => "user_id").map(&:user_id).uniq - except_ids).sort{rand(2)}[0..(COMRADE_SUGGESTION_SET_SIZE - 1)]
    end

    while true
      offset = rand(count)
      user_ids = GameCharacter.match(:server_id => server.id).offset(offset).limit(remain).all(:select => "user_id").map(&:user_id).uniq - except_ids
      except_ids = except_ids + user_ids
      suggestions = suggestions.concat(user_ids).uniq
      remain = FRIEND_SUGGESTION_SET_SIZE - suggestions.count
      if remain <= 0
        break
      end
    end
    suggestions	
  end

	def destroy_obsoleted_comrade_suggestions comrade
		ComradeSuggestion.delete_all(:user_id => id, :comrade_id => comrade.id)
	end

	def fetch_comrade_suggestions server
		suggestions = comrade_suggestions.all(:conditions => {:game_id => server.game_id, :server_id => server.id})

    suggestions
  end

  def create_comrade_suggestions server
    # destroy old suggestions
    ComradeSuggestion.delete_all(:user_id => id, :game_id => server.game_id, :server_id => server.id)

	  # construct new suggestions and insert into database
	  values = []
	  c_s = collect_comrades(server)
		c_s.each do |friend_id|
  		if server.game.no_areas
	  		values << "(NULL, #{id}, #{friend_id}, #{server.game_id}, NULL, #{server.id})"
		  else
			  values << "(NULL, #{id}, #{friend_id}, #{server.game_id}, #{server.area_id}, #{server.id})"
		  end
	  end

		c_s.clear
    # this is quite possible if no users play this game
		return if values.blank?
    # insert suggestions with one single sql
	  sql = "insert into comrade_suggestions values #{values.join(',')}"
		values.clear
	  ActiveRecord::Base.connection.execute(sql)
	end 

end
