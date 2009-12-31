#
# 如果你的好友最近开始玩某个游戏（或者停止玩某个游戏）
#
class CharacterFeedObserver < ActiveRecord::Observer

	observe :game_character

	def after_create character
		character.deliver_feeds :recipients => character.user.friends, :data => {:type => 0}
	end

  def after_update character
    if character.playing and !character.playing_was
      character.deliver_feeds :recipients => character.user.friends, :data => {:type => 1}
    elsif !character.playing and character.playing_was
      character.deliver_feeds :recipients => character.user.friends, :data => {:type => 2}
    end
  end

end
