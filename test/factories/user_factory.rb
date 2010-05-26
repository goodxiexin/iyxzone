class UserFactory

  def self.create cond={}
    user = Factory.create :user, cond
    user.activate
    user
  end

end
