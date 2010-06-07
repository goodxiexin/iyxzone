class UserFactory

  def self.create cond={}
    user = Factory.create :user, cond
    user.activate
    user
  end

  def self.create_idol cond={}
    self.create cond.merge({:is_idol => true})
  end

end
