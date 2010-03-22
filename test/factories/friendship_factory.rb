class FriendshipFactory

  def self.build cond
    Factory.build :friendship, cond || {}
  end  

  def self.build_friend user, friend
    f1 = Factory.build :user_id => user.id, :friend_id => friend.id
    f2 = Factory.build :friendship, :user_id => friend.id, :friend_id => user.id 
    [f1, f2]
  end

  def self.build_request user, friend
    Factory.build :friend_request, :user_id => user.id, :friend_id => friend.id
  end

  def self.create cond
    Factory.create :friendship, cond || {}
  end

  def self.create_friend user, friend
    f1 = Factory.create :friendship, :user_id => user.id, :friend_id => friend.id
    f2 = Factory.create :friendship, :user_id => friend.id, :friend_id => user.id
    [f1, f2]
  end

  def self.create_request user, friend
    Factory.create :friend_request, :user_id => user.id, :friend_id => friend.id
  end

end
