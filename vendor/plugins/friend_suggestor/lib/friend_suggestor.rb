# FriendSuggestor
module FriendSuggestor

	FRIEND_SUGGESTION_SET_SIZE = 50

	COMRADE_SUGGESTION_SET_SIZE = 50

	def collect_friends
    except_ids = [self.id]
    except_ids.concat self.friend_ids
    except_ids.concat self.request_friend_ids
    except_ids.concat self.requested_friend_ids
    # 避免2次create_friend_suggestions产生重复的结果
    except_ids.concat self.friend_suggestions.map(&:suggested_friend_id)
    except_ids.concat self.comrade_suggestions.map(&:comrade_id)
    # 去掉下面这2行的原因是，fan, idol可能太多了，而且现在fan, idol和friend2种关系可以共存
    #except_ids.concat User.match(:is_idol => true).all(:select => "id").map(&:id)
    #except_ids.concat fan_ids if is_idol?
    except_ids.uniq

    remain = FRIEND_SUGGESTION_SET_SIZE
    suggestions = []
    cond = "game_id IN (#{game_ids.join(',')}) and user_id NOT IN (#{except_ids.join(',')})"
    count = GameCharacter.match(cond).count

    if count <= remain
      return GameCharacter.match(cond).all(:select => "user_id").map(&:user_id).uniq
    end

    if count <=  5 * remain
      return (GameCharacter.match(cond).all(:select => "user_id").map(&:user_id).uniq).sort{rand(2)}[0..(FRIEND_SUGGESTION_SET_SIZE - 1)]
    end

    while true
      offset = rand(count)
      user_ids = GameCharacter.match(cond).offset(offset).limit(remain).all(:select => "user_id").map(&:user_id).uniq - except_ids
      suggestions = suggestions.concat(user_ids).uniq
      remain = FRIEND_SUGGESTION_SET_SIZE - suggestions.count
      break if remain <= 0
      except_ids = except_ids + user_ids
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
    s = Time.now
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
    puts "#{e-s} sec"
  end 
	
	def collect_comrades server
    except_ids = [self.id]
    except_ids.concat self.friend_ids
    except_ids.concat self.request_friend_ids
    except_ids.concat self.requested_friend_ids
    except_ids.concat self.friend_suggestions.map(&:suggested_friend_id)
    except_ids.concat self.comrade_suggestions.map(&:comrade_id)
    #except_ids.concat User.match(:is_idol => true).all(:select => "id").map(&:id).uniq
    #except_ids.concat fan_ids if is_idol?
    except_ids.uniq

    remain = COMRADE_SUGGESTION_SET_SIZE
    suggestions = []
    cond = "server_id = #{server.id} and user_id NOT IN (#{except_ids.join(',')})"
    count = GameCharacter.match(cond).count

    if count <= remain
      return GameCharacter.match(cond).all(:select => "user_id").map(&:user_id).uniq
    end

    if count <=  5 * remain
      return (GameCharacter.match(cond).all(:select => "user_id").map(&:user_id).uniq).sort{rand(2)}[0..(COMRADE_SUGGESTION_SET_SIZE - 1)]
    end

    while true
      offset = rand(count)
      user_ids = GameCharacter.match(cond).offset(offset).limit(remain).all(:select => "user_id").map(&:user_id).uniq - except_ids
      suggestions = suggestions.concat(user_ids).uniq
      remain = FRIEND_SUGGESTION_SET_SIZE - suggestions.count
      break if remain <= 0
      except_ids = except_ids + user_ids
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
    s = Time.now
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
	  puts "#{Time.now - s} sec"
  end 

end
