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
		recipients = [character.user.profile, character.game]
		recipients.concat character.user.friends
		character.deliver_feeds :recipients => recipients, :data => {:type => 0}
	end

  def after_update character
    # issue feeds
		recipients = [character.user.profile, character.game, character.guild]
		recipients.concat character.user.friends
    puts "recipients: #{recipients}"
    if character.playing and !character.playing_was
puts "开始不玩"
      character.deliver_feeds :recipients => recipients, :data => {:type => 1}
    elsif !character.playing and character.playing_was
puts "开始玩"
      character.deliver_feeds :recipients => recipients, :data => {:type => 2}
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
