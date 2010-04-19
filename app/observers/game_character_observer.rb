#
# 如果你的好友最近开始玩某个游戏（或者停止玩某个游戏）
#
class GameCharacterObserver < ActiveRecord::Observer

  def before_create character
    # increment counter
    character.user.raw_increment :games_count unless character.user.games.include?(character.game)
  end
	
  def after_create character
    # increment counter
    character.game.raw_increment :characters_count
    character.user.raw_increment :characters_count

    # issue feeds if necessary
		recipients = [character.user.profile, character.game]
		recipients.concat character.user.friends
		character.deliver_feeds :recipients => recipients, :data => {:type => 0}
	end

  def after_update character
    # issue feeds
		recipients = [character.user.profile, character.game, character.guild]
		recipients.concat character.user.friends
    if character.playing and !character.playing_was
      character.deliver_feeds :recipients => recipients, :data => {:type => 1}
    elsif !character.playing and character.playing_was
      character.deliver_feeds :recipients => recipients, :data => {:type => 2}
    end
  end

  def after_destroy character
    # increment counter
    character.game.raw_decrement :characters_count
    character.user.raw_decrement :characters_count

    # decrement game counter if necessary
		character.user.raw_decrement :games_count unless character.user.has_game? character.game_id

    # issue feeds if necessary
    # TODO: 这里是有点问题的, 因为feed_item的originator是空的，但是deliver_feeds方法还是会自动赋值的
    recipients = [character.user.profile]
    recipients.concat character.user.friends
    character.deliver_feeds :recipients => recipients, :data => {:type => 3, :character => character}
  end

end
