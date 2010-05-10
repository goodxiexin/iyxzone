#
# 如果你的好友最近开始玩某个游戏（或者停止玩某个游戏）
#
class GameCharacterObserver < ActiveRecord::Observer

  def before_create character
    # increment counter
    character.user.raw_increment :games_count unless character.user.has_game? character.game_id
  end
	
  def after_create character
    # increment counter
    character.game.raw_increment :characters_count
    character.user.raw_increment :characters_count

    # issue feeds if necessary
		character.deliver_feeds :data => {:type => 0}
	end

  def after_update character
    # issue feeds
    if character.playing and !character.playing_was
      character.deliver_feeds :data => {:type => 1}
    elsif !character.playing and character.playing_was
      character.deliver_feeds :data => {:type => 2}
    end
		
		# if it is wow or wow tw characters, verifying need to be operated again
		g1 = Game.find_by_name("魔兽世界")
		g2 = Game.find_by_name("魔兽世界（台服）")
		if (character.game_id == g1.id or character.game_id == g2.id) and !character.data.nil?
			character.data = nil
		end
  end

  def after_destroy character
    # increment counter
    character.game.raw_decrement :characters_count
    character.user.raw_decrement :characters_count

    # decrement game counter if necessary
		character.user.raw_decrement :games_count unless character.user.has_game? character.game_id
  end

end
