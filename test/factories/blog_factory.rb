class BlogFactory

  def self.build cond={}
    user = UserFactory.create
    blog = Factory.build :blog, {:game_id => user.games.first.id, :poster_id => user.id}.merge(cond)
    blog
  end

  def self.create cond={}
    user = UserFactory.create
    blog = Factory.create :blog, {:game_id => user.games.first.id, :poster_id => user.id}.merge(cond)
    blog
  end

end

class DraftFactory

  def self.build cond={}
    user = UserFactory.create
    blog = Factory.build(:draft, {:game_id => user.games.first.id, :poster_id => user.id}.merge(cond))
    blog
  end

  def self.create cond={}
    user = UserFactory.create
    blog = Factory.create(:draft, {:game_id => user.games.first.id, :poster_id => user.id}.merge(cond))
    blog
  end

end

