#
# 如果你的好友最近开始玩某个游戏（或者停止玩某个游戏）
#
class GameCharacterObserver < ActiveRecord::Observer

	def after_create character
    # increment counter
    character.game.raw_increment :characters_count
    character.user.raw_increment :characters_count

    # issue feeds
		character.deliver_feeds :recipients => character.user.friends, :data => {:type => 0}
	end

  def after_update character
    if character.playing and !character.playing_was
      character.deliver_feeds :recipients => character.user.friends, :data => {:type => 1}
    elsif !character.playing and character.playing_was
      character.deliver_feeds :recipients => character.user.friends, :data => {:type => 2}
    end
  end

  def after_destroy character
    # increment counter
    character.game.raw_decrement :characters_count
    character.user.raw_decrement :characters_count

    # issue feeds
    character.deliver_feeds :recipients => character.user.friends, :data => {:type => 3}
  end

end
