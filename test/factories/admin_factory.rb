class AdminFactory

  def self.create cond={}
    user = Factory.create :user, cond
    user.activate
    Role.find_or_create :name => 'admin'
    user.add_role 'admin'
    user
  end

end
