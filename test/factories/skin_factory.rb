class SkinFactory

  def self.create cond={}
    Factory.create :skin, {:privilege => Skin::PUBLIC, :category => 'Profile'}.merge(cond)
  end

end
