class OnlineUser < ActiveRecord::Base

  belongs_to :user

  ONLINE = 0
  BUSY = 1
  LEAVE = 2
  HIDE = 3

  def online_friend_infos
    User.find(online_friend_ids).map {|f| {:login => f.login, :id => f.id, :avatar => avatar_path(f), :pinyin => f.pinyin}}
  end

  def online_friend_ids
    user.friendships.map(&:friend_id) & OnlineUser.all.map(&:user_id) 
  end

end
