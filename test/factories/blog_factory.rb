class BlogFactory

  def self.create cond={}
    # create poster
    poster = Factory.create :user

    # create blog
    Factory.create :blog, {:poster_id => poster.id, :draft => 0}.merge(cond)
  end

end

class DraftFactory

  def self.create cond={}
    # create poster
    poster = Factory.create :user
    
    # create blog
    # 之所有这么做，是因为，数据校验太复杂了，他会检查你是否有该游戏
    Factory.create :blog, {:poster_id => poster.id, :draft => 1}.merge(cond)
  end

end 
