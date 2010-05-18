class UserFactory

  def self.create cond={}
    Factory.create :user, cond
  end

end
