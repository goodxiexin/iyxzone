class AddAdmin < ActiveRecord::Migration
  def self.up
    admin = User.new
    admin.login = "admin"
    admin.password = "Gaoxh1065"
    admin.password_confirmation = "Gaoxh1065"
    admin.email = "daye@17gaming.com"
    admin.save(false)
    admin.activate

    roel = Role.create(:name => 'admin')
    
    RoleUser.create(:role_id => role.id, :admin_id => admin.id)
  end

  def self.down
  end
end
