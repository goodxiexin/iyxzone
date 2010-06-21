class FriendFactory

  def self.create user1, user2
    Friendship.create(:user_id => user1.id, :friend_id => user2.id, :status => Friendship::Friend)
    Friendship.create(:user_id => user2.id, :friend_id => user1.id, :status => Friendship::Friend)
  end

end
